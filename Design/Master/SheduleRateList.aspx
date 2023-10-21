<%@ Page Language="C#"  ClientIDMode="Static" AutoEventWireup="true" EnableEventValidation="false"  
CodeFile="SheduleRateList.aspx.cs" Inherits="Design_EDP_SheduleRateList"  %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
    <!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title></title>
       
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/App_Style/css" />
<webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/jquery-ui.css" /> 
     <webopt:BundleReference ID="BundleReference5" runat="server" Path="~/App_Style/chosen.css" />
<link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 

    </head>
    <body >
    
    <form id="form1" runat="server">


     <Ajax:ScriptManager ID="ScriptManager2" runat="server" LoadScriptsBeforeUI="true"   EnablePageMethods="true">  
<Scripts>
     <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
     <asp:ScriptReference Path="~/Scripts/jquery.multiple.select.js" />
     <asp:ScriptReference Path="~/Scripts/chosen.jquery.js" />
     <asp:ScriptReference Path="~/Scripts/Common.js" />

</Scripts>
</Ajax:ScriptManager>
     
   <div class="POuter_Box_Inventory"  style="text-align:center;">
    <b>Shedule Rate List</b><br />

  </div>
   <div class="POuter_Box_Inventory">
    <div class="Purchaseheader"> Search criteria</div>   
       <div class="row">
           <div class="col-md-8"><asp:RadioButtonList ID="rblRateType"  runat="server" RepeatDirection="Horizontal" RepeatLayout="Table" onchange="changeRateType()">
                                    <asp:ListItem Text="Rate Type Only" Value="1" Selected="True" ></asp:ListItem>
                                    <asp:ListItem Text="Referal Rate Of Client" Value="2" ></asp:ListItem>
                                         </asp:RadioButtonList></div>
            <div class="col-md-16"></div>
       </div>
       <div class="row">
           <div class="col-md-4">Sub Group :</div>
           <div class="col-md-8"><asp:DropDownList ID="ddlDepartment0" runat="server" class="ddlDepartment0  chosen-select" onchange="Getsubcategory()"  Width="229px" > </asp:DropDownList></div>
           <div class="col-md-4">Billing Category :</div>
           <div class="col-md-8"><asp:DropDownList ID="ddlbillcategory" Width="228px" runat="server" class="ddlbillcategory  chosen-select" onchange="GetDepartmentItem()">
                                 <asp:ListItem Value="0">Routine</asp:ListItem>
                                 <asp:ListItem Value="1">Special</asp:ListItem>
                            </asp:DropDownList></div>
           </div>
        <div class="row">
           <div class="col-md-4">Department :</div>
           <div class="col-md-8"> <asp:DropDownList ID="ddlDepartment" runat="server" class="ddlDepartment  chosen-select" onchange="GetDepartmentItem()"  
                                    Width="229px" > </asp:DropDownList></div>
           <div class="col-md-4">Item Name :</div>
           <div class="col-md-8"> <asp:DropDownList ID="ddlItem" runat="server"  class="ddlItem  chosen-select"  Width="228px" onchange="getPanelItemRate();Search();"  > </asp:DropDownList></div>
           </div>
        <div class="row" style="display:none;">
           <div class="col-md-4">Business Zone :</div>
           <div class="col-md-8"><asp:DropDownList ID="ddlBusinessZone" runat="server"  class="ddlItem  chosen-select" onchange="bindState()" Width="228px"> </asp:DropDownList></div>
           <div class="col-md-4">State :</div>
           <div class="col-md-8"><asp:DropDownList ID="ddlState" runat="server"  class="ddlItem  chosen-select" onchange="bindPanel();"  Width="228px"> </asp:DropDownList></div>
           </div>
          <div class="row">
           <div class="col-md-4">Type :<asp:DropDownList ID="ddlType" runat="server"  class="ddlType  chosen-select" onchange="bindPanel();getClientRate()" style="text-align:left;"  Width="70px"> </asp:DropDownList>
               &nbsp;&nbsp;Panel :
           </div>
           <div class="col-md-8"> 
               <asp:DropDownList ID="lstPanel" runat="server"  class="lstPanel  chosen-select" onchange="getPanelItemRate();Search();" style="text-align:left;"  Width="228px"> </asp:DropDownList>
               <label id="lblPanel" style="color:red" runat="server"></label>
               <%--<asp:ListBox ID="lstPanel" CssClass="multiselect" SelectionMode="Multiple" Width="230px" runat="server" ClientIDMode="Static"></asp:ListBox>--%>

           </div>
           <div class="col-md-4">Rate :</div>
           <div class="col-md-8"> <input id="txtRate" style="width: 110px;text-align:center;" type="text" class="numbersOnly"  placeholder="Enter Rate" />&nbsp;&nbsp;
               <input id="txtOldRate" style="width: 110px;text-align:center;" type="text" readonly="false" class="numbersOnly"  placeholder="Old Rate" />
                             <span id="spnCCClientRate" style="display:none">  Share Rate :&nbsp;<input id="txtClientRate" style="width: 110px;text-align:center;" type="text" class="numbersOnly"  placeholder="Enter Client Rate" /></span> </div>
           </div>
        <div class="row">
           <div class="col-md-4">From Date :</div>
           <div class="col-md-8"><asp:TextBox ID="txtfromdate"  runat="server" ClientIDMode="Static" placeholder="Enter From Date" Width="120px" Style="padding-left: 10px;"></asp:TextBox>
                            <cc1:calendarextender ID="ce_dtfrom"  runat="server" Format="dd-MMM-yyyy"  TargetControlID="txtfromdate" /></div>
           <div class="col-md-4">To Date :</div>
           <div class="col-md-8"><asp:TextBox ID="txttodate"  runat="server" ClientIDMode="Static" placeholder="Enter To Date" Width="120px" Style="padding-left: 10px;"></asp:TextBox>
                            <cc1:calendarextender ID="ce_dtto" runat="server"  Format="dd-MMM-yyyy" TargetControlID="txttodate" /> </div>
           </div>        
   </div> 
   <div class="POuter_Box_Inventory" style="text-align:center; padding-top:5px; padding-bottom:5px;">  
       <div class="row"><div class="col-md-24">
            <button id="btnSave" type="button" class="btn " onclick="SaveRate(this)" style="width:100px;">Save</button>                      
           <button id="Button1" type="button" class="btn " onclick="Search()">Search</button>                   
        <button id="Buttonex" type="button"  class="btn " onclick="ExportToExcel()"  /> Export To Excel</button>   
           <input type="checkbox" id="chkall" name="chkall" />
                        </div> </div>      
              
   </div>
   <div class="POuter_Box_Inventory"> 
     <div id="div_InvestigationItems"  style="max-height:800px; overflow-y:auto; overflow-x:hidden;">
        
        </div>
       <div class="POuter_Box_Inventory" style="margin-top:10px;"> 
               <!-- The Modal -->
               <asp:Button ID="btnHideSin" runat="server" Style="display:none" />
                <cc1:ModalPopupExtender ID="mpRemoveRate" runat="server" CancelControlID="btnclose"
                            DropShadow="true" TargetControlID="btnHideSin" BackgroundCssClass="filterPupupBackground"
                            PopupControlID="pnlRemoveRate"  OnCancelScript="closePopup()">
                        </cc1:ModalPopupExtender>  
 <asp:Panel ID="pnlRemoveRate" runat="server" Style="display: none;width:450px; " CssClass="pnlVendorItemsFilter">
   <div class="Purchaseheader"  runat="server">
            <table style="width:100%; border-collapse:collapse" border="0">
                <tr>
                    <td>
                        <b>Info</b>
                    </td>
                    <td style="text-align:right">
                        <em ><span style="font-size: 7.5pt"> Press esc or click
                            <img id="btnclose" src="../../App_Images/Delete.gif" style="cursor:pointer"  onclick="closePopup()"/>                             
                                to close</span></em>
                    </td>
           </tr>
                </table>          
        </div>   

    <div id="divSendSampleDetail" style="padding:15px;">
 <div style="">             
      <p style="text-align:left;"><b>Reason :&nbsp;</b> </p>
         
      <p>
          <input id="hdnItemID" type="hidden" value="0" />
          <input id="hdnPanelID" type="hidden" value="0" />  
          <input id="hdnFromDate" type="hidden" value="" />
          <input id="hdnToDate" type="hidden" value="" />       
          <input id="txtupdateremarks" type="text" required  style="width:100%; height:30px;" value="" /></p>
    </div>
    </div>  
      
    <div style="text-align:right;">
     <div style="margin-bottom: 15px;margin-right: 15px;">         
         <button id="btnupdate" type="button" class="btn " onclick="UpdateRate(this)">Save</button>
         &nbsp;&nbsp;<button id="btncancel" class="btn" type="button" onclick="closePopup()">Cancel</button>
     </div>
    </div>
  

</asp:Panel>
               
        </div> 
   </div>     
   <script id="tb_InvestigationItems" type="text/html">        
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch" style="border-collapse:collapse;width:1290px;"> 
		<tr >
			<th class="GridViewHeaderStyle" scope="col" style="width:30px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:70px;">Panel Code</th>			
			<th class="GridViewHeaderStyle" scope="col" style="width:150px;">Panel Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:70px;">Test Code</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Item Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:70px;">Rate</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:70px;">From Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:70px;">To Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">&nbsp;</th>
			  
        </tr>

       <#
       
              var dataLength=PatientData.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {            

        objRow = PatientData[j];
       #>
            <tr  style="background-color:White;">
            <td class="GridViewLabItemStyle" style="text-align:center;" ><#=j+1#></td>
            <td  class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.PanelCode#></td>
            <td  class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.PanelName#></td>
            <td  class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.TestCode#></td>
            <td class="GridViewLabItemStyle"  style=" text-align:center"><#=objRow.ItemName#></td>
            <td class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.Rate#></td>
             <td class="GridViewLabItemStyle" style="text-align:center;" ><#=objRow.FromDate#></td> 
             <td class="GridViewLabItemStyle" style="text-align:center;" ><#=objRow.ToDate#></td> 
             <td class="GridViewLabItemStyle" style="text-align:center;" ><a href="#" id="btndelete" fromdate="<#=objRow.FromDate#>" todate="<#=objRow.ToDate#>" onclick="deleteRow('<#=objRow.ItemID#>',<#=objRow.PanelID#>,this)"><img style="width: 15px;" src="../../App_Images/Delete.gif" /></a></td> 
            </tr>    
      <#}#>

        </table>    
    </script> 


    <script type="text/javascript">
        function getPanelItemRate() {
            serverCall('SheduleRateList.aspx/getPanelItemRate', { ItemID: $("#<%=ddlItem.ClientID %>").val(),PanelID:$("#<%=lstPanel.ClientID %>").val() }, function (response) {
                if (response != "1") {
                    $('#txtOldRate').val(response.split('#')[0]);
                    $('#lblPanel').html('RateType:- ' + response.split('#')[1]);
                }

            });
        }
        function SaveRate() {
             if (IsVailid() == "1") {
                 return;
             }
             $("#btnSave").attr('disabled', 'disabled').text("Saving...");
             var PanelID = '';
             //var SelectedLaength = $('#lstPanel').multipleSelect("getSelects").join().split(',').length;
             //for (var i = 0; i <= SelectedLaength - 1; i++) {
             //    PanelID += $('#lstPanel').multipleSelect("getSelects").join().split(',')[i] + ',';
             //}           
             PanelID=$("#<%=lstPanel.ClientID %>").val()
             var Itemdata = '';
             var Itemdata = $("#<%=ddlItem.ClientID %>").val() + '|0|' + $("#txtRate").val() + '|' + $("#txtfromdate").val() + '|' + $("#txttodate").val() + '|' + $("#txtClientRate").val() + '#';


            try {
                serverCall('SheduleRateList.aspx/saveRate', { ItemData:  Itemdata , PanelID:  PanelID , RateType:  jQuery('#rblRateType input[type=radio]:checked').val()  }, function (response) {
                    if (response == "1") {
                        alert("Record Saved Successfully", "");                       
                        $("#txtRate,#txtClientRate,#txtfromdate,#txttodate").val('');
                        $("#btnSave").removeAttr('disabled').text("Save");
                        Search();
                    }
                    else if (response == "2") {
                        alert("This date range already exists in your system !.", "");
                        $("#btnSave").removeAttr('disabled').text("Save");

                    }
                    else {
                        alert("Record Not Saved", "");
                        $("#btnSave").removeAttr('disabled').text("Save");
                    }
                   });
               }
               catch (e) {
                   alert("Error Occured..!", "");
                   $("#btnSave").removeAttr('disabled').text("Save");
               }                      
        }

        function IsVailid() {
            var con = 0;

            if (jQuery.trim(jQuery('#<%=ddlItem.ClientID %>').val()) == "0") {                
                alert("Please Select Item", "");
                jQuery('#<%=ddlItem.ClientID %>').focus();                
              //  toast("Error", "Please Select a Item Name .", "");
                con = 1;
                return con;
            }
            if (jQuery('#<%=lstPanel.ClientID %>').val() != null) {
                var PanelID = '';
                //var SelectedLaength = $('#lstPanel').multipleSelect("getSelects").join().split(',').length;
                //for (var i = 0; i <= SelectedLaength - 1; i++) {
                //    PanelID += $('#lstPanel').multipleSelect("getSelects").join().split(',')[i] + ',';
                //}
                PanelID=$("#<%=lstPanel.ClientID %>").val();
                if (PanelID.replace(',', '') == "") {                    
                    alert("Please Select Panel...!", "");
                    $("#<%=lstPanel.ClientID %>").focus();
                    con = 1;
                    return con;
                }

            }
            if (jQuery.trim(jQuery('#txtRate').val()) == "") {                
                alert("Please Enter Rate", "");
                jQuery('#txtRate').focus();
                con = 1;
                return con;
            }
            if (jQuery.trim(jQuery('#txtClientRate').val()) == "" && jQuery('#ddlType option:selected').text() == "CC") {                
                alert("Please Enter Client Rate", "");
                jQuery('#txtClientRate').focus();
                return 1;
            }
            if (jQuery.trim(jQuery('#txtfromdate').val()) == "") {                
                alert("Please Enter From Date", "");
                jQuery('#txtfromdate').focus();
                con = 1;
                return con;
            }
            if (jQuery.trim(jQuery('#txttodate').val()) == "") {                
                alert("Please Enter To Date", "");
                jQuery('#txttodate').focus();                           
                con = 1;
                return con;
            }
            var fromDate = new Date(jQuery('#txtfromdate').val());
            var toDate = new Date(jQuery('#txttodate').val());

            if (toDate < fromDate) {
                jQuery('#txttodate').focus();                
                alert("To date cannot be less than From date.", "");
                con = 1;
                return con;
            }


        }
  </script>
    <script type="text/javascript">

        var PatientData = "";
        function Search() {
            var PanelID = '';
            if ($("#<%=lstPanel.ClientID %>").val() != null) {
                //var SelectedLaength = $('#lstPanel').multipleSelect("getSelects").join().split(',').length;
                //for (var i = 0; i <= SelectedLaength - 1; i++) {
                //    PanelID += $('#lstPanel').multipleSelect("getSelects").join().split(',')[i].split('#')[0] + ',';
                //}
                PanelID=$("#<%=lstPanel.ClientID %>").val();
                if (PanelID.replace(',','') == "") {                    
                    alert("Please Select Panel", "");
                    return;
                }
            }
            try {
                serverCall('SheduleRateList.aspx/GetRateList', { ItemID: '0' ,PanelID: PanelID ,RateType: jQuery('#rblRateType input[type=radio]:checked').val() }, function (response) {
                    PatientData = jQuery.parseJSON(response);
                    var output = $('#tb_InvestigationItems').parseTemplate(PatientData);
                    $('#div_InvestigationItems').html(output);
                    $("#tb_grdLabSearch :text").hide();
                    $('#tb_grdLabSearch tr:even').addClass("GridViewAltItemStyle");
                });
            }
            catch (e) {
                alert("Error Occured..!", "");
            }
        }
  </script>    
    <script type="text/javascript">
        $(function () {
            $('.numbersOnly').keyup(function () {
                this.value = this.value.replace(/[^0-9\.]/g, '');
            });

            $('.txtonly').keyup(function () {
                this.value = this.value.replace(/[^A-Z\.\a-z\ ]/g, '');
            });
        });
        $(function () {
          
            Getsubcategorygroup();
            bindPanel();
        });

        var PatientData = "";
        function GetDepartmentItem() {
            $("#<%=ddlItem.ClientID %> option").remove();

            try {
                serverCall('../Lab/Services/ItemMaster.asmx/GetDepartmentWiseItem', { SubCategoryID: $("#<%=ddlDepartment.ClientID %>").val(), billcategory: $("#<%=ddlbillcategory.ClientID %>").val() }, function (response) {
                    PatientData = jQuery.parseJSON(response);
                    if (PatientData.length == 0) {
                        $("#<%=ddlItem.ClientID %>").append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        for (i = 0; i < PatientData.length; i++) {
                            $("#<%=ddlItem.ClientID %>").append($("<option></option>").val(PatientData[i].ItemID).html(PatientData[i].TypeName));
                        }
                    }

                    if ($("#<%=ddlItem.ClientID %>").val() != "0") {
                        // Search();
                    }
                    $("#<%=ddlItem.ClientID %>").attr("disabled", false);
                    $("#<%=ddlItem.ClientID %>").trigger('chosen:updated');
                });
            }
              catch (e) {
                  alert("Error Occured..!", "");
              }
        }
        function Getsubcategorygroup() {
            $("#<%=ddlDepartment0.ClientID %> option").remove();
            try {
                serverCall('../Lab/Services/ItemMaster.asmx/Getsubcategorygroupnew', { }, function (response) {
                     PatientData = jQuery.parseJSON(response);
                     if (PatientData.length == 0) {
                         $("#<%=ddlDepartment0.ClientID %>").append($("<option></option>").val("0").html("---No Data Found---"));
                      }
                     else {
                         $("#<%=ddlDepartment0.ClientID %>").append($("<option></option>").val("All").html("All"));
                          for (i = 0; i < PatientData.length; i++) {
                              $("#<%=ddlDepartment0.ClientID %>").append($("<option></option>").val(PatientData[i].Displayname).html(PatientData[i].Displayname));
                        }
                    }
                    

                    $("#<%=ddlDepartment0.ClientID %>").trigger('chosen:updated');
                    Getsubcategory();
                });
            }
            catch (e) {
                alert("Error Occured..!", "");
            }
        };
        function Getsubcategory() {
            $("#<%=ddlDepartment.ClientID %> option").remove();  
            try {
                serverCall('../Lab/Services/ItemMaster.asmx/Getsubcategorynew', {CategoryId:  $("#<%=ddlDepartment0.ClientID %>").val() }, function (response) {
                    PatientData = jQuery.parseJSON(response);
                    if (PatientData.length == 0) {
                        $("#<%=ddlDepartment.ClientID %>").append($("<option></option>").val("0").html("---No Data Found---"));
                     }
                    else {
                        $("#<%=ddlDepartment.ClientID %>").append($("<option></option>").val("All").html("All"));
                         for (i = 0; i < PatientData.length; i++) {
                             $("#<%=ddlDepartment.ClientID %>").append($("<option></option>").val(PatientData[i].SubcategoryID).html(PatientData[i].Name));
                        }
                    }
                    

                    $("#<%=ddlDepartment.ClientID %>").attr("disabled", false);
                    $("#<%=ddlDepartment.ClientID %>").trigger('chosen:updated');
                    //  GetDepartmentItem();
                    GetDepartmentItem();
                });
            }
            catch (e) {
                alert("Error Occured..!", "");
            }          
        };       
    </script> 
    <script type="text/javascript">
        $(document).ready(function () {
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
        function bindState() {
            jQuery("#lblMsg").text('');
            jQuery("#<%=ddlState.ClientID%> option").remove();
            jQuery('#<%=lstPanel.ClientID%> option').remove();
            jQuery("#<%=ddlState.ClientID%>").trigger('chosen:updated');           
            PageMethods.bindState(jQuery('#<%=ddlBusinessZone.ClientID%>').val(), onSucessState, onFailureState);
        }

        function onSucessState(result) {
            var stateData = jQuery.parseJSON(result);
           
            if (stateData.length == 0) {
                jQuery("#<%=ddlState.ClientID%>").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
            }
            else {
                jQuery("#<%=ddlState.ClientID%>").append(jQuery("<option></option>").val("").html("Select"));
                jQuery("#<%=ddlState.ClientID%>").append(jQuery("<option></option>").val("0").html("All"));
                for (i = 0; i < stateData.length; i++) {
                    jQuery("#<%=ddlState.ClientID%>").append(jQuery("<option></option>").val(stateData[i].ID).html(stateData[i].State));
                }

            }
            jQuery("#<%=ddlState.ClientID%>").trigger('chosen:updated');

          //  bindPanel();
        }
        function onFailureState() {

        }
    </script>
    <script type="text/javascript">
        function bindPanel() {
          // if (jQuery('#<%=ddlState.ClientID%> option:selected').val() == "") {
          //     jQuery('#<%=lstPanel.ClientID%> option').remove();                
          //    // Search();
          // }
          //  else
                PageMethods.bindPanel(jQuery('#<%=ddlBusinessZone.ClientID%>').val(), jQuery('#<%=ddlState.ClientID%>').val(), jQuery('#<%=ddlType.ClientID%> option:selected').text(), jQuery('#rblRateType input[type=radio]:checked').val(), onSuccessPanel, OnfailurePanel);

        }
          function onSuccessPanel(result) {            
              jQuery('#<%=lstPanel.ClientID%> option').remove();
              var panelData;
              if (result != undefined && result.length > 0) {
                  panelData = jQuery.parseJSON(result);
              }
              if (panelData == undefined || panelData == null || panelData.length == 0) {
                  jQuery("#<%=lstPanel.ClientID%>").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
              }

              if (panelData != undefined && panelData != null && panelData.length != 0) {                  
                  for (i = 0; i < panelData.length; i++) {                      
                      jQuery('#<%=lstPanel.ClientID%>').append(jQuery("<option></option>").val(panelData[i].Panel_ID).html(panelData[i].Company_Name));
                  }
              }
              $("#<%=lstPanel.ClientID %>").attr("disabled", false);
              jQuery("#<%=lstPanel.ClientID%>").trigger('chosen:updated');
              //$('[id*=lstPanel]').multipleSelect({
              //    includeSelectAllOption: true,
              //    filter: true, keepOpen: false
              //});          
          }
          function OnfailurePanel() {

          }
    </script>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                closePopup();
            }
        }
        function deleteRow(ItemID, PanelID, event) {

            $('#hdnItemID').val(ItemID);
            $('#hdnPanelID').val(PanelID);
            $('#hdnFromDate').val($(event).attr("fromdate"));
            $('#hdnToDate').val($(event).attr("todate"));
            $find("<%=mpRemoveRate.ClientID%>").show();


         }
         function closePopup() {

             $('#hdnItemID').val("0");
             $('#hdnPanelID').val("0");
             $('#hdnFromDate').val('');
             $('#hdnToDate').val('');
             $('#txtupdateremarks').val("");             
             $find("<%=mpRemoveRate.ClientID%>").hide();
         }
         function UpdateRate(e) {
             var ItemID = $('#hdnItemID').val();
             var PanelID = $('#hdnPanelID').val();
             var FromDate = $('#hdnFromDate').val();
             var ToDate = $('#hdnToDate').val();
             var UpdateRemarks = $('#txtupdateremarks').val();
             if (jQuery.trim(UpdateRemarks) == "") {                 
                 alert("Please Enter Reason.", "");
                 $('#txtupdateremarks').focus();
                 return;
             }
             $("#btnupdate").attr('disabled', 'disabled').text("Saving...");
             try {
                 serverCall('SheduleRateList.aspx/updateRate', { ItemID:  ItemID , PanelID:  PanelID , UpdateRemarks:  UpdateRemarks , FromDate:  FromDate , ToDate:  ToDate  }, function (response) {
                     
                      if (response == "1") {                          
                          alert("Item Removed Successfully.", "");
                          $("#btnupdate").removeAttr('disabled').text("Save");
                          closePopup();
                          Search();
                      }
                      else {
                          alert("Item Not Removed", "");
                          $("#btnupdate").removeAttr('disabled').text("Save");
                      }
                });
            }
            catch (e) {           
                alert("Error has occurred Record Not Removed.", "");
                $("#btnupdate").removeAttr('disabled').text("Save");
            }
        }

     </script>
    <script type="text/javascript">
        $(function () {
        //    $('[id*=lstPanel]').multipleSelect({
        //        includeSelectAllOption: true,
        //        filter: true, keepOpen: false
        //    });
        });
        //$('#lstPanel').on('change', function () {
        //    $('#tb_grdLabSearch tr').not(':first').empty();
        //    getPanelItemRate();
        //    Search();
        //});
       
    </script>
<style type="text/css">
.GridViewHeaderStyle {    
      height: 25px!important;
}
[type=text] {
    padding: 3px 0px;
    margin: 0px 0;
    display: inline-block;
    border: 1px solid #ccc;
    border-radius: 5px;
    box-sizing: border-box;
 }

input[type="button"]
{
    
    outline:none;
}


.btn{display:inline-block;*border-bottom: 0 none #b3b3b3;
        display:inline;*zoom:1;padding:4px 12px;margin-bottom:0;font-size:14px;line-height:20px;text-align:center;vertical-align:middle;cursor:pointer;color:#333333;text-shadow:0 1px 1px rgba(255, 255, 255, 0.75);background-color:#f5f5f5;background-repeat:repeat-x;border-color:rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.25);*-webkit-border-radius: 4px;
        -moz-border-radius: 4px;
        border-radius: 4px;
        margin-left: .3em;
        -webkit-box-shadow: inset 0 1px 0 rgba(255, 255, 255, .2), 0 1px 2px rgba(0, 0, 0, .05);
        -moz-box-shadow: inset 0 1px 0 rgba(255, 255, 255, .2), 0 1px 2px rgba(0, 0, 0, .05);
        box-shadow: inset 0 1px 0 rgba(255, 255, 255, .2), 0 1px 2px rgba(0, 0, 0, .05);
        background-image: linear-gradient(to bottom, #ffffff, #e6e6e6);
**border-left-style: none;
        border-left-color: inherit;
        border-left-width: 0;
        border-right-style: none;
        border-right-color: inherit;
        border-right-width: 0;
        border-top-style: none;
        border-top-color: inherit;
        border-top-width: 0;
    }.btn:hover,.btn:focus,.btn:active,.btn.active,.btn.disabled,.btn[disabled]{color:#333333;background-color:#e6e6e6;*background-color:#d9d9d9;}
.btn:active,.btn.active{background-color:#cccccc;} 
.btn:hover,.btn:focus{color:#333333;text-decoration:none;background-position:0 -15px;-webkit-transition:background-position 0.1s linear;-moz-transition:background-position 0.1s linear;-o-transition:background-position 0.1s linear;transition:background-position 0.1s linear;}
  
    </style>
    <script type="text/javascript">
        function changeRateType() {
            bindPanel();
        }

        function ExportToExcel() {
            try {
                var chkall = '0';
                if (jQuery('#chkall').prop('checked')) chkall = 1;
                serverCall('SheduleRateList.aspx/ExportToExcel', { chkall: chkall, PanelID: $("#<%=lstPanel.ClientID %>").val() }, function (response) {
                    if (response == "1") {
                        window.open('../common/ExportToExcel.aspx');
                    }
                    else {                      
                        alert(response, "");
                    }                 
                });
            }
            catch (e) {
                alert("Some Error Occur Please Try Again..!", "");
                $('#btnsave').attr('disabled', false).val("Save");
                console.log(xhr.responseText);
            }                    
        }

        function getClientRate() {
            if ($("#ddlType option:selected").text() == "CC") {
                $("#spnCCClientRate").show();
            }
            else {
                $("#spnCCClientRate").hide();
                $("#txtClientRate").val('');
            }
        }
    </script>
</form>
</body>
</html>

