<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ObservationManage.aspx.cs" Inherits="Design_Investigation_ObservationManage" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <%: System.Web.Optimization.Scripts.Render("~/bundles/MsAjaxJs") %>
   <script type="text/javascript" src="../../Scripts/jquery.tablednd.js"></script>
    <style type="text/css">
        .reflexsapn {
            cursor: pointer;
            background-color: blue;
            color: white;
            border-radius: 15px;
            font-weight: bold;
            padding: 5px;
        }
    </style>



   <Ajax:ScriptManager ID="sm1" runat="server" />

    <div  id="Pbody_box_inventory">
    <div class="POuter_Box_Inventory">
    <asp:Panel ID="pnlNewObs" runat="server" CssClass="pnlVendorItemsFilter" Style="display:none; width:400px;" Width="351px" Height="235px" >
        <div class="Purchaseheader" id="Div4" runat="server">
        New Observation</div>
    <div class="row">
        <div class="col-md-12">
            Add Observation :
        </div>
         <div class="col-md-12">
              <asp:TextBox ID="txtObservation" runat="server"  MaxLength="100"  ></asp:TextBox>
        </div>
        <div class="col-md-12">
             Short Name :
        </div>
         <div class="col-md-12">
             <asp:TextBox ID="txtObsShortName" runat="server"   MaxLength="20"  ></asp:TextBox> 
        </div>
        <div class="col-md-12">
            Suffix :
        </div>
         <div class="col-md-12">
              <asp:TextBox ID="txtObsSuffix" runat="server"  MaxLength="10"  ></asp:TextBox> 
        </div>
        <div class="col-md-12">
            <asp:CheckBox ID="chkIsCulture" runat="server"  Text="IsCultureReport"/>
        </div>
         <div class="col-md-12">
             <asp:CheckBox ID="chkObsAnylRpt" Checked="true" runat="server" Text="Show in Patient Report"/>
        </div>
        <div class="col-md-12">
             Round Off :
        </div>
         <div class="col-md-12">
              <asp:DropDownList ID="ddlRoundOff"  runat="server">
                    <asp:ListItem Value="0">0</asp:ListItem>
                    <asp:ListItem  Value="1">1</asp:ListItem>
                    <asp:ListItem  Value="2" Selected="True">2</asp:ListItem>
                    <asp:ListItem  Value="3">3</asp:ListItem>
                    <asp:ListItem  Value="4">4</asp:ListItem>
                    <asp:ListItem  Value="5">5</asp:ListItem>
                    <asp:ListItem  Value="6">6</asp:ListItem>
                    </asp:DropDownList>
        </div>
        <div class="col-md-12">Master Gender :
        </div>
        <div class="col-md-12">
            <asp:DropDownList ID="ddlGender2" runat="server" >
         <asp:ListItem Value="B">Both</asp:ListItem>
        <asp:ListItem Value="M">Male</asp:ListItem>
         <asp:ListItem Value="F">Female</asp:ListItem>
        </asp:DropDownList>
        </div>
        <div class="col-md-12">
                     <asp:CheckBox ID="chkIPrintSeparateOBS" Text="Print Separate" runat="server" /> 
        </div>
        <div class="col-md-12">
            <asp:CheckBox ID="chkPrintLabReport" Text="Print Lab Report" Checked="true" runat="server" />
        </div>
        <div class="col-md-24">
             <asp:CheckBox ID="chkAllowDubBooking" Text="Allow Duplicate Booking" runat="server" />
        </div>
    
         
   <div class="filterOpDiv" >
          <input id="btnAddObs" type="button" value="Save" onclick="AddnewObservation();" class="ItDoseButton"/>
        <asp:Button ID="btnCancelObs" runat="server" CssClass="ItDoseButton" Text="Cancel" CausesValidation="false" />
    </div>
    </div>     
    </asp:Panel>

 <cc1:ModalPopupExtender ID="mpeNewObs" runat="server"
    CancelControlID="btnCancelObs"
    DropShadow="true"
    TargetControlID="btnNewObs" 
    BackgroundCssClass="filterPupupBackground"
    PopupControlID="pnlNewObs"
    PopupDragHandleControlID="Div4" >
</cc1:ModalPopupExtender> 

    <div class="Purchaseheader">
        Mapped Observation</div>
        <div class="row">
            <div class="col-md-4">
                 Current Investigation :  
            </div>
            <div class="col-md-12" style="text-align:left">
                  <asp:Label ID="lblInvestigation" runat="server" Font-Size="Medium" ForeColor="Green" style="text-align:left"></asp:Label>
            </div>
            
            <div class="col-md-2"> 
                </div>
            <div class="col-md-6" style="text-align:right">
                <a href="#" onclick="openme()" style="float:right;">Add Abnormal Image</a>
            </div>
        </div>
        <div class="row">
            <div class="col-md-3">
                 Map Observation :
            </div>
            <div class="col-md-6">
                <asp:DropDownList ID="ddlObservation" runat="server"  onchange="ddlobschange();"   CssClass="ItDoseDropdownbox">
            </asp:DropDownList> 
                </div>
            <div class="col-md-2">
                 <asp:Button ID="btnNewObs" runat="server" Text="New Observation" CssClass="ItDoseButton" style="display:none" /> 
                  <input id="btnAdd" type="button"  value="Map Observation"  onclick="AddObs()"/>
            </div>
            <div class="col-md-3">
                 <input id="btnAddNewObs" type="button"  value="Create New Observation"  onclick="AddNewObs()"/>
            </div>
        </div>
     </div>
        <div class="POuter_Box_Inventory"  >
        <div id="div_mapobservation" style="display:none">
          
        </div>
             </div>
         <div class="POuter_Box_Inventory"   > 
        <div id="div_InvestigationItems"  style="max-height:450px; overflow-y:auto; overflow-x:hidden;">
                
            </div>
        </div>
         <div class="POuter_Box_Inventory" style=" padding-top:2px;padding-bottom:2px; text-align:center;">
        <input id="btnSave" type="button" onclick="observationmap();"  value="Save Mapping"/>
        </div>
   
  
    </div> 

<script id="tb_InvestigationItems" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch" 
    style="border-collapse:collapse;">
		<tr class="nodrop" id="tr_Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:20px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:20px;">ID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:200px;">Observation Name</th>
	        <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Prefix</th>
           
            <th class="GridViewHeaderStyle" scope="col" style="width:50px; display:none;">Method</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:20px;">Header</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:20px;">Critical</th>
            		<th class="GridViewHeaderStyle" scope="col" style="width:20px;">AMR</th>
            		<th class="GridViewHeaderStyle" scope="col" style="width:20px;">Reflex</th>
             

			<th class="GridViewHeaderStyle" scope="col" style="width:20px;">Comment</th>
	        <th class="GridViewHeaderStyle" scope="col" style="width:20px;">Bold</th>
	        <th class="GridViewHeaderStyle" scope="col" style="width:20px;">UnderLine</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:20px;">PrintSeprate</th>
             <th class="GridViewHeaderStyle" scope="col" style="width:20px;">HelpValue Only</th>
            <% if(isautoconsume=="1")
                   
               { %>
            <th class="GridViewHeaderStyle" scope="col" style="width:20px;">AutoConsume</th>
            <%} %>
             <th class="GridViewHeaderStyle" scope="col" style="width:20px;">Inter pretation</th>
              <th class="GridViewHeaderStyle" scope="col" style="width:20px;">Reflex Test</th>
               <th class="GridViewHeaderStyle" scope="col" style="width:20px;">MicroScopy</th>
             <th class="GridViewHeaderStyle" scope="col" style="width:20px;">ParentID</th>
           
            <th class="GridViewHeaderStyle" scope="col" style="width:20px;display:none;">Hold Test</th>
	        <th class="GridViewHeaderStyle" scope="col" style="width:20px;">Edit</th>
	        <th class="GridViewHeaderStyle" scope="col" style="width:20px;">Remove</th>	
</tr>
       <#      
              var dataLength=obsData.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {

        objRow = obsData[j];
        
            #>
                    <tr id="<#=objRow.LabObservation_ID#>"  >
<td class="GridViewLabItemStyle" onmouseover="chngcurmove()"><#=j+1#></td>
                        <td class="GridViewLabItemStyle" id="tdLabObservation_ID" onmouseover="chngcurmove()"><#=objRow.LabObservation_ID#></td>
<td class="GridViewLabItemStyle" id="tdLabObservationName" onmouseover="chngcurmove()"><#=objRow.ObsName#></td>
<td class="GridViewLabItemStyle" onmouseover="chngcurmove()"><input id="txtPrefix" type="text" value="<#=objRow.Prefix#>" /></td>
 
<td class="GridViewLabItemStyle" onmouseover="chngcurmove()" style="display:none;"><input id="txtMethod" type="text" value="<#=objRow.MethodName#>" /></td>

<#
       if(objRow.Child_Flag==1)
           { #>
<td class="GridViewLabItemStyle"><input id="chkHeader" type="checkbox" Checked='true' onmouseover="chngcur()"   /></td>
<#}else{#>
 <td class="GridViewLabItemStyle"><input id="chkHeader" type="checkbox" onmouseover="chngcur()"  /></td>
<#}#>
 <# if(objRow.IsCritical==1)
           { #>
<td class="GridViewLabItemStyle"><input id="chkCritical" type="checkbox" Checked='true' onmouseover="chngcur()"  /></td>
<#}else{#>
                     
 <td class="GridViewLabItemStyle"><input id="chkCritical" type="checkbox" onclick="IsCritical1('<#=objRow.LabObservation_ID#>')" onmouseover="chngcur()"   /></td>
<#}#>

                       
<# if(objRow.isamr==1)
           { #>
<td class="GridViewLabItemStyle"><input id="chkisamr" type="checkbox" Checked='true' onmouseover="chngcur()"  /></td>
<#}else{#>
 <td class="GridViewLabItemStyle"><input id="chkisamr" type="checkbox" onmouseover="chngcur()"   /></td>
<#}#>


                        
<# if(objRow.isreflex==1)
           { #>
<td class="GridViewLabItemStyle"><input id="chkisreflex" type="checkbox" Checked='true' onmouseover="chngcur()" onclick="showreflex(this)"  /></td>
<#}else{#>
 <td class="GridViewLabItemStyle"><input id="chkisreflex" type="checkbox" onmouseover="chngcur()"  onclick="showreflex(this)"   /></td>
<#}#>



<# if(objRow.IsComment==1)
           { #>
<td class="GridViewLabItemStyle"><input id="chkcomment" type="checkbox" Checked='true' onmouseover="chngcur()"  /></td>
<#}else{#>
 <td class="GridViewLabItemStyle"><input id="chkcomment" type="checkbox" onmouseover="chngcur()"   /></td>
<#}#>

<# if(objRow.IsBold==1)
           { #>
 <td class="GridViewLabItemStyle"><input id="chkBold" Checked='true' type="checkbox" onmouseover="chngcur()"   />
 <#}else{#>
 <td class="GridViewLabItemStyle"><input id="chkBold" type="checkbox" onmouseover="chngcur()"   />
 <#}#>
 
 <# if(objRow.IsUnderLine==1)
           { #>
  <td class="GridViewLabItemStyle"><input id="chkUnderLine" Checked='true' type="checkbox" onmouseover="chngcur()"   />
  <#}else{#>
    <td class="GridViewLabItemStyle"><input id="chkUnderLine" type="checkbox" onmouseover="chngcur()"   />
 <#}#>


   <td class="GridViewLabItemStyle">
       <# if(objRow.SepratePrint==1)
           { #>
       <input id="chkprintseprate" type="checkbox" checked="checked"    />
       <#} else {#>
       <input id="chkprintseprate" type="checkbox"     />
       <#}#>
       </td>
         <td class="GridViewLabItemStyle">
       <# if(objRow.chkhelp==1)
           { #>
       <input id="chkhelp" type="checkbox" checked="checked"    />
       <#} else {#>
       <input id="chkhelp" type="checkbox"     />
       <#}#>
       </td>
        <% if(isautoconsume=="1")
               
           { %>
        <td  class="GridViewLabItemStyle">
            <# if(objRow.isautoconsume=="1")
           { #>
            <input id="chkautoconsume" 
            <% if(autoconsumeoption!="2")
                   
               { %>
        style="display:none;"

      
            <%} %> 
       type="checkbox" checked="checked"   />
            <#}
            else
            {
            #>
<input id="chkautoconsume" 
            <% if(autoconsumeoption!="2")
                   
               { %>
        style="display:none;"

      
            <%} %> 
       type="checkbox"   />

<#}#>
  
        </td>

        <%} %>
<td  class="GridViewLabItemStyle" align="center"><img id="img1" src="../../App_Images/folder.gif" style="cursor:pointer;"   onclick="window.open('AddInterpretation.aspx?obsid=<#=objRow.LabObservation_ID#>&invID=<%=Investigation_ID %>')" title="Interpretation"/></td>



        <td  class="GridViewLabItemStyle" align="center"><span id="reflex" 
            <# if(objRow.isreflex==1)
           { #>
            style="cursor:pointer;background-color:blue;color:white;border-radius:15px;font-weight:bold;padding:5px;" 
            <#}
            else{
            #>
            style="display:none;"
            <#}#>
              onclick="window.open('InvestigationReflectTest.aspx?obsid=<#=objRow.LabObservation_ID#>&invID=<%=Investigation_ID %>')" title="Reflex Test">R</span></td>


        <# if(objRow.MICROSCOPY==1)
           { #>
  <td class="GridViewLabItemStyle"><input id="chkMicroScopy" Checked='true' type="checkbox" onmouseover="chngcur()"   />
  <#}else{#>
    <td class="GridViewLabItemStyle"><input id="chkMicroScopy" type="checkbox" onmouseover="chngcur()"   />
 <#}#>

    <td class="GridViewLabItemStyle"><input id="txtparentid" type="text" value="<#=objRow.ParentId#>" style="width:50px;" /></td>
          <td style="display:none;" class="GridViewLabItemStyle" align="center"><span id="maptestid" style="cursor:pointer;background-color:red;color:white;border-radius:15px;font-weight:bold;padding:5px;"  onclick="window.open('InvestigationHoldMap.aspx?obsid=<#=objRow.LabObservation_ID#>&invID=<%=Investigation_ID %>')" title="Reflex Test" >H</span> 
        

<td  class="GridViewLabItemStyle"><img id="imgEdit" src="../../App_Images/edit.png"   onmouseover="chngcur()"/></td>
<td class="GridViewLabItemStyle"><img id="imgRmv" src="../../App_Images/Delete.gif"  onclick="removeObservation(this)"  onmouseover="chngcur()" /></td>
<#}#>
</tr>

            

     </table>    
    </script>
          <script type="text/javascript">
              jQuery(function () {
                  var Investigation_ID = '<%=Investigation_ID %>';
              if (Investigation_ID != "") {
                  jQuery('#ctl00_ddlUserName').hide();
                  jQuery('.Hider').hide();
              }
              else {
                  jQuery('#ctl00_ddlUserName').show();
                  jQuery('.Hider').show();
              }
              BindObsGrid();
          });
          function chngcur() {
              document.body.style.cursor = 'pointer';

          }
          function chngcurmove() {
              document.body.style.cursor = 'move';
          }
          function BindObsGrid() {
              jQuery.ajax({
                  url: "Services/MapInvestigationObservation.asmx/GetObservationData",
                  data: '{ InvestigationID: "' + '<%=Investigation_ID %>' + '"}', // parameter map
                  type: "POST", // data has to be Posted    	        
                  contentType: "application/json; charset=utf-8",
                  timeout: 120000,
                  dataType: "json",
                  success: function (result) {
                      obsData = jQuery.parseJSON(result.d);
                      var output = jQuery('#tb_InvestigationItems').parseTemplate(obsData);
                      jQuery('#div_InvestigationItems').html(output);
                      jQuery("#tb_grdLabSearch").tableDnD
                      ({
                          onDragClass: "GridViewDragItemStyle",
                          onDragStart: function (table, row) {                            
                          }
                      });
                      tablefunctioning();
                  },
                  error: function (xhr, status) {
                      alert("Error ");
                  }
              });
          }
              function removeObservation(rowID) {
                  if (confirm("Do You Want to Remove Observation") == false) {
                      return false;
                  }
                 var obsID= $(rowID).closest('tr').find("#tdLabObservation_ID").text();
                 RemoveObs(obsID);
              }
          function tablefunctioning() {
              jQuery("#tb_grdLabSearch tr").find("#chkHeader").filter(':checked').each(function () {
                  jQuery(this).closest("tr").addClass('GridViewChkHeaderStyle');
              });

             // jQuery("#tb_grdLabSearch").find("#imgRmv").click(function () {
                  
                  
             // });

              bindimgeditclick();
              unbindimgeditclick();
              unbindimgeditclick_comment();
              jQuery("#tb_grdLabSearch").find("#chkHeader").click(function () {

                  MakeHeader(jQuery(this).closest("tr").attr("id"))
                  unbindimgeditclick();
              });
              //jQuery("#tb_grdLabSearch").find("#chkCritical").click(function () {
                 
              //    if (IsCritical(jQuery(this).parents("tr").find('#tdLabObservation_ID').text())=="1") {
              //        SetCritical(jQuery(this).closest("tr").attr("id"))
              //    }
              //    else {
              //        alert('Please define critical range value');
              //        jQuery("#" + jQuery(this).closest("tr").attr("id")).find("#chkCritical").prop('checked', false);
              //    }
              //});
              jQuery("#tb_grdLabSearch").find("#chkcomment").click(function () {
                  unbindimgeditclick_comment();
              });
          }

          function IsCritical1(ObsId) {              
              //jQuery("#tb_grdLabSearch").find("#chkCritical").click(function () {
              if (IsCritical(ObsId) == "1") {
                  SetCritical(ObsId);
                 }
                else {
                  alert('Please define critical range value');
                  jQuery("#tb_grdLabSearch").find('#' + ObsId).find("#chkCritical").prop('checked', false);
                   //  jQuery("#" + jQuery(this).closest("tr").attr("id")).find("#chkCritical").prop('checked', false);
                }
            // });
          }
          function AddObs() {
              $("#btnAdd").attr('disabled', 'disabled').val('Submitting...');
              var DuplicateObs = '0';
              if ('<%=Investigation_ID %>' == "") {
                  DuplicateObs = '1';
                  alert('Please Select an Investigation');
                  $("#btnAdd").removeAttr('disabled').val('Map Observation');
                  
                  return;
              }
              jQuery("#tb_grdLabSearch tr").each(function () {
                  if (jQuery(this).attr("id") != "tr_Header") {
                      if (jQuery(this).closest("tr").find("#tdLabObservation_ID").text() == jQuery("#<%=ddlObservation.ClientID %>").val()) {
                          DuplicateObs = '1';
                          alert('Observation already added');
                          $("#btnAdd").removeAttr('disabled').val('Map Observation');
                          return;
                      }
                  }
              });
              if (DuplicateObs != '1') {
                  saveobs(jQuery("#<%=ddlObservation.ClientID %>").val());
                  BindObsGrid();
                  $("#btnAdd").removeAttr('disabled').val('Map Observation');
              }
          }
          function saveobs(ObsID) {
              jQuery.ajax({
                  url: "Services/MapInvestigationObservation.asmx/SaveObservation",
                  data: '{ InvestigationID: "' + '<%=Investigation_ID %>' + '",ObservationId:"' + ObsID + '"}', 
                  type: "POST",         
                  contentType: "application/json; charset=utf-8",
                  timeout: 120000,
                  dataType: "json",
                  async:false,
                  success: function (result) {
                      alert('Record Saved Successfully');
                      $("#btnAdd").removeAttr('disabled').val('Map Observation');
                  },
                  error: function (xhr, status) {
                      alert("Error ");
                      $("#btnAdd").removeAttr('disabled').val('Map Observation');
                  }
              });

          }
          function AddNewObs() {
              if ('<%=Investigation_ID %>' == "") {
                  alert('Please Select an Investigation');
                  return;
              }
              $find('<%=mpeNewObs.ClientID %>').show();
          }

          // open popup to add new observation End
</script>

<%--Create New Observation--%>

 <script type="text/javascript">
     function AddnewObservation() {
         
         var RoundOff = jQuery('#<%=ddlRoundOff.ClientID %>').val();

         if (jQuery.trim(jQuery("#<%=txtObservation.ClientID%>").val()) == "") {
             alert("Observation Name Cannot be Blank");
             jQuery("#<%=txtObservation.ClientID%>").focus();
             return;
         }


         if (jQuery("#<%=txtObsSuffix.ClientID%>").val().length > 6) {
             alert("Suffix Length Cannot Be More Then 6");
             jQuery("#<%=txtObsSuffix.ClientID%>").focus();
             return;
         }


         var IsCulture = jQuery("#<%=chkIsCulture.ClientID %>").is(':checked') ? 1 : 0;
         var ObsAnylRpt = jQuery("#<%=chkObsAnylRpt.ClientID %>").is(':checked') ? 1 : 0;
         var PrintSeparate = jQuery("#<%=chkIPrintSeparateOBS.ClientID %>").is(':checked') ? 1 : 0;
         var PrintInLab = jQuery("#<%=chkPrintLabReport.ClientID %>").is(':checked') ? 1 : 0;
         var AllowDubB = jQuery("#<%=chkAllowDubBooking.ClientID %>").is(':checked') ? 1 : 0;
	
         jQuery.ajax({
             url: "Services/MapInvestigationObservation.asmx/SaveNewObservation",
             data: '{ ObsName: "' + jQuery("#<%=txtObservation.ClientID %>").val() + '",ShortName: "' + jQuery("#<%=txtObsShortName.ClientID %>").val() + '",Suffix: "' + jQuery("#<%=txtObsSuffix.ClientID %>").val() + '",IsCulture: "' + IsCulture + '",ObsAnylRpt: "' + ObsAnylRpt + '",RoundOff:"' + jQuery("#<%=ddlRoundOff.ClientID %>").val() + '",Gender:"' + jQuery("#<%=ddlGender2.ClientID %>").val() + '",PrintSeparate:"' + PrintSeparate + '",PrintInLabReport:"' + PrintInLab + '",AllowDuplicateBooking:"' + AllowDubB + '"}', // parameter map
             type: "POST",
             contentType: "application/json; charset=utf-8",
             timeout: 120000,
             dataType: "json",
             success: function (result) {
                 if (result.d == '0') {
                     alert('Observation Already Exist');
                     return;
                 }
                 $find('<%=mpeNewObs.ClientID %>').hide();
                 saveobs(result.d);
                 BindObsGrid();
                 
                 jQuery("#<%=ddlObservation.ClientID %>").append(jQuery("<option></option>").val(result.d).html(jQuery("#<%=txtObservation.ClientID %>").val()));

                 jQuery("#<%=txtObservation.ClientID %>,#<%=txtObsShortName.ClientID %>,#<%=txtObsSuffix.ClientID %>").val('');
                 jQuery("#<%=chkIsCulture.ClientID %>,#<%=chkObsAnylRpt.ClientID %>,#<%=chkIPrintSeparateOBS.ClientID %>").prop('checked', false);
                 jQuery("#<%=ddlRoundOff.ClientID %>,#<%=ddlGender2.ClientID %>").prop('selectedIndex',0);
                 
                 
             },
             error: function (xhr, status) {
                 alert("Error ");
             }
         });
     }
 </script>  
 <%--Create New observation End--%>
 <%--  map observation TO investigation start--%>
 <script type="text/javascript">
     var a = 1;
     function observationmap() {
         jQuery('input,select').attr('disabled', true);
         var ObsOrder = "";
         jQuery("#tb_grdLabSearch tr").each(function () {
             
             if (jQuery(this).attr("id") != "tr_Header") {
                 ObsOrder += jQuery(this).closest("tr").attr("id") + '|' + jQuery(this).find('#txtPrefix').val() + '|0|0|' + jQuery(this).find('#txtMethod').val() + '|';
                 if (jQuery(this).closest("tr").children().find("#chkHeader").is(':checked'))
                     ObsOrder += '1|';
                 else
                     ObsOrder += '0|';
                 if (jQuery(this).closest("tr").children().find("#chkCritical").is(':checked'))
                     ObsOrder += '1|';
                 else
                     ObsOrder += '0|';
                 if (jQuery(this).closest("tr").children().find("#chkcomment").is(':checked'))
                     ObsOrder += '1|';
                 else
                     ObsOrder += '0|';
                 if (jQuery(this).closest("tr").children().find("#chkBold").is(':checked'))
                     ObsOrder += '1|';
                 else
                     ObsOrder += '0|';
                 if (jQuery(this).closest("tr").children().find("#chkUnderLine").is(':checked'))
                     ObsOrder += '1|';
                 else
                     ObsOrder += '0|';

                 if (jQuery(this).closest("tr").children().find("#chkprintseprate").is(':checked'))
                     ObsOrder += '1|';
                 else
                     ObsOrder += '0|';

                 if (jQuery(this).closest("tr").children().find("#chkautoconsume").is(':checked'))
                     ObsOrder += '1|';
                 else
                     ObsOrder += '0|';

                 if (jQuery(this).closest("tr").children().find("#chkisamr").is(':checked'))
                     ObsOrder += '1|';
                 else
                     ObsOrder += '0|';

                 if (jQuery(this).closest("tr").children().find("#chkisreflex").is(':checked'))
                     ObsOrder += '1|';
                 else
                     ObsOrder += '0|';

                 if (jQuery(this).closest("tr").children().find("#chkhelp").is(':checked'))
                     ObsOrder += '1|';
                 else
                     ObsOrder += '0|';

                 if (jQuery(this).closest("tr").children().find("#chkMicroScopy").is(':checked'))
                     ObsOrder += '1|';
                 else
                     ObsOrder += '0|';

                 ObsOrder += jQuery(this).find('#txtparentid').val() + "#";


             }
         });
         jQuery.ajax({
             url: "Services/MapInvestigationObservation.asmx/SaveMapping",
             data: '{ InvestigationID: "' + <%=Investigation_ID %> + '",Order:"' + ObsOrder + '"}', 
                     type: "POST",    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     success: function (result) {
                         if (result.d == '1') {
                             alert('Record Saved SuccessFully');
                             clearform();
                             BindObsGrid();
                             jQuery('input,select').attr('disabled', false);
                         }
                         if (result.d == '0') {
                             alert('Record Not Saved');
                             jQuery('input,select').attr('disabled', false);
                         }
                     },
                     error: function (xhr, status) {
                         alert("Error ");
                         jQuery('input,select').attr('disabled', false);
                     }
                 });
             }
             function clearform() {
                 jQuery(':text, textarea').val('');
                 jQuery(".chk").find(':checkbox').prop('checked', false);
                 jQuery(":checkbox:not(#chkNewInv)").prop("checked", false);
                 jQuery("#tb_grdLabSearch tr").remove();
             }
             
             function bindimgeditclick() {
                 jQuery("#tb_grdLabSearch tr").each(function () {
                     jQuery(this).find("#imgEdit").bind("click", function () {
                         a = 1;
                         openpopup(jQuery(this).closest("tr").find("#tdLabObservation_ID").text(), jQuery(this).closest("tr").find('#tdLabObservationName').text());
                     });
                 });
             }
             function unbindimgeditclick_comment() {
                 jQuery("#tb_grdLabSearch tr").each(function () {
                     var Header = jQuery(this).find("#chkHeader");
                     var critical = jQuery(this).find("#chkCritical");
                     var iscomment = jQuery(this).find("#chkcomment").is(":checked");
                     var edit = jQuery(this).find("#imgEdit");
                     if (iscomment == true) {
                         jQuery(Header).attr("disabled", "disabled");
                         jQuery(critical).attr("disabled", "disabled");
                         jQuery(edit).unbind('click');
                     }
                     else {
                         if (jQuery(Header).is(":checked") == false) {
                             jQuery(Header).removeAttr("disabled");
                             jQuery(critical).removeAttr("disabled");
                             jQuery(edit).bind("click", function () {
                                 openpopup(jQuery(this).closest("tr").find("#tdLabObservation_ID").text(), jQuery(this).closest("tr").find('#tdLabObservationName').text());
                             });
                         }
                     }
                 });
             }
             function openpopup(ObsId, ObsName) {
                 if (a == 1) {
                     window.open('../Investigation/EditObservationDetail.aspx?ObsId=' + ObsId + '&InvId=' + '<%=Investigation_ID %>', null, 'left=150, top=100, height=520, width=1000,  resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');
             }
             a = 2;
         }
         function unbindimgeditclick() {
             jQuery("#tb_grdLabSearch tr").each(function () {
                 var ischecked = jQuery(this).find("#chkHeader").is(":checked");
                 var critical = jQuery(this).find("#chkCritical");
                 var comment = jQuery(this).find("#chkcomment");
                 var edit = jQuery(this).find("#imgEdit");

                 if (ischecked == true) {
                     jQuery(critical).attr("disabled", "disabled");
                     jQuery(comment).attr("disabled", "disabled");
                     jQuery(edit).unbind('click');
                 }
                 else {
                     jQuery(critical).removeAttr("disabled");
                     jQuery(comment).removeAttr("disabled");
                     jQuery(edit).bind("click", function () {
                         openpopup(jQuery(this).closest("tr").find("#tdLabObservation_ID").text(), jQuery(this).closest("tr").find('#tdLabObservationName').text());
                     });
                 }

             });
         }

         function RemoveObs(ObsId) {
             jQuery.ajax({
                 url: "Services/MapInvestigationObservation.asmx/RemoveObservation",
                 data: '{ InvestigationID: "' + '<%=Investigation_ID %>' + '",ObservationId:"' + ObsId + '"}', 
                     type: "POST",       
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     success: function (result) {
                         if (result.d == 1) {
                             jQuery("#" + ObsId).remove();
                             alert('Record Removed Successfully');
                             BindObsGrid();
                         }
                     },
                     error: function (xhr, status) {
                         alert("Error ");
                     }
                 });
             }
             function SetCritical(ObsId) {
                 if (jQuery("#tb_grdLabSearch").find('#' + ObsId).find("#chkCritical").is(':checked')) {
                     if (confirm("Do You Want to set Critical Level for this Observation") == true) {
                         jQuery("#" + ObsId).removeClass('GridViewChkHeaderStyle');
                         jQuery("#" + ObsId).find("#chkHeader").prop('checked', false);
                     }
                     else {
                         jQuery("#tb_grdLabSearch").find("#" + ObsId).find("#chkCritical").prop('checked', false);
                         return false;
                     }
                 }
                 else {
                     if (confirm("Do You Want to Remove Critical Level for this Observation") == true)
                         jQuery("#" + ObsId).removeClass('GridViewChkHeaderStyle');
                     else {
                         jQuery("#tb_grdLabSearch").find('#' + ObsId).find("#chkCritical").prop('checked', 'checked');
                         return false;
                     }
                 }

             }
          

             function MakeHeader(ObsId) {
                 if (jQuery("#tb_grdLabSearch").find('#' + ObsId).find("#chkHeader").is(':checked')) {
                     if (confirm("Do You Want to this Observation Make Header") == true) {
                         jQuery("#" + ObsId).find("#chkCritical").prop('checked', false);
                         jQuery("#" + ObsId).addClass('GridViewChkHeaderStyle');
                     }
                     else {
                         jQuery("#tb_grdLabSearch").find('#' + ObsId).find("#chkHeader").prop('checked', false);
                         return false;
                     }
                 }
                 else {
                     if (confirm("Do You Want to Remove Header") == true)
                         jQuery("#" + ObsId).removeClass('GridViewChkHeaderStyle');
                     else {
                         jQuery("#tb_grdLabSearch").find('#' + ObsId).find("#chkHeader").prop('checked', 'checked');
                         return false;
                     }
                 }


             }
             function ddlobschange() {

                 jQuery.ajax({

                     url: "Services/MapInvestigationObservation.asmx/GetMapObservation",
                     data: '{ LabObservationID: "' + jQuery("#<%=ddlObservation.ClientID %>").val() + '"}', 
                     type: "POST", 	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     success: function (result) {
                         jQuery("#div_mapobservation").html(result.d);
                         jQuery("#div_mapobservation").css("display", "");
                         jQuery("#div_mapobservation").css("color", "green");
                     },
                     error: function (xhr, status) {
                         alert("Error ");

                         window.status = status + "\r\n" + xhr.responseText;
                     }
               });
             }


             function openme() {
                 window.open("AddAbnormalImage.aspx", null, 'left=150, top=100, height=520, width=1000,  resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');
             }

             function showreflex(ctrl) {
                 if (jQuery(ctrl).is(':checked')) {
                     jQuery(ctrl).closest('tr').find('#reflex').show();
                     jQuery(ctrl).closest('tr').find('#reflex').addClass("reflexsapn");

                 }
                 else {
                     jQuery(ctrl).closest('tr').find('#reflex').hide();
                 }
             }


             function IsCritical(LabObservationID) {
                 var val = "0";
                 jQuery.ajax({
                     url: "ObservationManage.aspx/CheckCritical",
                     data: '{ LabObservationID: "' + LabObservationID + '" }', // parameter map                     
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     async: false,
                     success: function (result) {
                         if (result.d == '1') {
                             val = "1";
                         }
                         if (result.d == '0') {
                             val = "0";
                         }
                     },
                     error: function (xhr, status) {
                         val = "0";
                     }
                 });
                 return val;
             }
    </script>  
          <%--  map observation TO investigation End--%>
</asp:Content>

