<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ManageOrdering.aspx.cs" Inherits="Design_Investigation_ManageOrdering" Title="Untitled Page" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <%: System.Web.Optimization.Scripts.Render("~/bundles/MsAjaxJs") %>
    <script src="../../Scripts/jquery.tablednd.js"></script>
    
   
     <div id="Pbody_box_inventory">
    <div class="POuter_Box_Inventory">
    <div class="content">
    <div style="text-align:center;">
    <b>Manage Ordering </b></div>
     <div style="text-align:center;">
         &nbsp;<br />
         <asp:RadioButtonList ID="rblSearchType" runat="server" RepeatDirection="Horizontal">
            
             <asp:ListItem Value="1" Selected="True">Department</asp:ListItem>
             <asp:ListItem Value="2">SubGroup</asp:ListItem>
              <asp:ListItem  Value="0">Investigation</asp:ListItem>
        </asp:RadioButtonList></div>
     </div>
        
   </div>
   <div class="POuter_Box_Inventory">
    <div class="Purchaseheader"> 
        Search criteria</div>
        <div class="POuter_Box_Inventory"> 
                    <table id="TBMain" border="0" cellpadding="0" cellspacing="0" style="width: 100%; height: 28px;">
                         <tr>
                           
                            <td style="width: 12%" align="right">
                                SubCategory :&nbsp; 
                            </td>
                            <td style="width: 24%" align="left">
                             <asp:DropDownList ID="ddlSubCategory" runat="server" onchange="Search()" CssClass="ItDoseDropdownbox"
                                    Width="228px"> </asp:DropDownList>
                               
                            </td>
                              <td style="width: 64%" align="left" id="tdsubgroup">
                                   SubGroup:
                                <asp:DropDownList ID="ddlsubgroup" runat="server" onchange="SearchInv()" Width="220px"></asp:DropDownList>
                              </td>
                        </tr>
                     </table> 
        
        </div>
     <div class="POuter_Box_Inventory" style="text-align:center; "  > 
        <div id="div_InvestigationItems"  style="max-height:500px; overflow-y:auto; overflow-x:hidden;">
                </div>
            </div>
      <div class="POuter_Box_Inventory" style="text-align:center; "  > 
      <input id="Save" type="button" value="Save Ordering" style="display:none" />
     </div>
     </div>
     
     
     
     </div>
     
     <script id="tb_InvestigationItems" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch" 
    style="border-collapse:collapse; cursor: move;" >
		<tr id="Header" class="nodrop">
			<th class="GridViewHeaderStyle" scope="col" style="width:20px;">S.No</th>		
			<th class="GridViewHeaderStyle" scope="col" style="width:200px;">Item Name</th>
			
	       

</tr>

       <#
       
              var dataLength=PatientData.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {

        objRow = PatientData[j];
         
            #>
                    <tr id="<#=objRow.ID#>" >
<td class="GridViewLabItemStyle"><#=j+1#></td>
<td id="<#=objRow.ID#>"  class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.Name#></td>

</tr>

            <#}#>

     </table>    
    </script>


     <script type="text/javascript">
         var PatientData = "";
         jQuery(function () {
             jQuery('#TBMain').hide();
             jQuery('#tdsubgroup').hide();
             SearchDept();
             jQuery("#<%=rblSearchType.ClientID %>").click(function () {                
                 if ($("#<%=rblSearchType.ClientID%>").find(":checked").val() == '1') {
                     clearform();
                     jQuery('#TBMain').hide();
                     SearchDept();                    
                 }
                 else if ($("#<%=rblSearchType.ClientID%>").find(":checked").val() == '2') {
                     clearform();
                     jQuery('#TBMain').show();
                    // Searchsubgroup();
                 }
                 else if ($("#<%=rblSearchType.ClientID%>").find(":checked").val() == '0') {
                    
                     jQuery('#TBMain').show();
                     jQuery('#tdsubgroup').show();
                     clearform();
                     $bindsubgroup($('#<%=ddlSubCategory.ClientID%>').val().split('#')[0]);
                    
                 }
             });
             jQuery("#Save").click(function () {
                 if ($("#<%=rblSearchType.ClientID%>").find(":checked").val() == '0')
                     saveInvOrdering();
                 else if ($("#<%=rblSearchType.ClientID%>").find(":checked").val() == '1')
                     saveDeptOrdering();
                 else
                     savesubgroupOrdering();
             });

         });

         function saveInvOrdering() {
             var InvOrder = "";
             jQuery("#tb_grdLabSearch tr").each(function () {
                 if (jQuery(this).attr('id') != "Header")
                     InvOrder += jQuery(this).attr('id') + '|';
             });
             jQuery.ajax({
                 url: "Services/MapInvestigationObservation.asmx/SaveInvOrdering",
                 data: '{InvOrder: "' + InvOrder + '"}',
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     if (result.d == '1') {
                         alert('Record Saved SuccessFully');
                         clearform();
                         jQuery("#Save").hide();
                     }
                 },
                 error: function (xhr, status) {
                     alert("Error.. Record Not saved ");
                 }
             });
         }
         function saveDeptOrdering() {
             var DeptOrder = "";
             jQuery("#tb_grdLabSearch tr").each(function () {
                 if (jQuery(this).attr('id') != "Header")
                     DeptOrder += jQuery(this).attr('id') + '|';

             });
             jQuery.ajax({
                 url: "Services/MapInvestigationObservation.asmx/SaveDeptOrdering",
                 data: '{DeptOrder: "' + DeptOrder + '"}',
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     if (result.d == '1') {
                         alert('Record Saved SuccessFully');
                         clearform();
                         SearchDept();
                     }
                 },
                 error: function (xhr, status) {
                     alert("Error.. Record Not saved ");
                 }
             });


         }
         function savesubgroupOrdering() {
             var DeptOrder = "";
             jQuery("#tb_grdLabSearch tr").each(function () {
                 if (jQuery(this).attr('id') != "Header")
                     DeptOrder += jQuery(this).attr('id') + '|';

             });
             jQuery.ajax({
                 url: "Services/MapInvestigationObservation.asmx/SavesubgroupOrdering",
                 data: '{DeptOrder: "' + DeptOrder + '"}',
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     if (result.d == '1') {
                         alert('Record Saved SuccessFully');
                         clearform();
                         Searchsubgroup();
                     }
                 },
                 error: function (xhr, status) {
                     alert("Error.. Record Not saved ");
                 }
             });


         }
         function Search() {
             if ($("#<%=rblSearchType.ClientID%>").find(":checked").val() == '2') {
                 Searchsubgroup();
             }
             else if ($("#<%=rblSearchType.ClientID%>").find(":checked").val() == '0') {
               
                 $bindsubgroup($('#<%=ddlSubCategory.ClientID%>').val().split('#')[0]);
               
             }
         }
         $bindsubgroup = function (deptid) {
             serverCall('../Common/Services/CommonServices.asmx/loadsubgroup', { deptID: deptid }, function (response) {
                 debugger;
                 var DeptData = JSON.parse(response);
                 jQuery('#<%=ddlsubgroup.ClientID%> option').remove();
                 if (DeptData != null) {
                     jQuery('#<%=ddlsubgroup.ClientID%>').append(jQuery("<option></option>").val(0).html('--select--'));
                     for (i = 0; i < DeptData.length; i++) {
                         jQuery('#<%=ddlsubgroup.ClientID%>').append(jQuery("<option></option>").val(DeptData[i].ID).html(DeptData[i].SubgroupName));
                     }
                     SearchInv();
                 }
             });
         }
         function SearchInv() {
             jQuery.ajax({
                 url: "Services/MapInvestigationObservation.asmx/GetInvPriorty",
                 data: '{SubCategoryId: "' + jQuery("#<%=ddlSubCategory.ClientID %>").val() + '",SubGroupID:"' + $('#<%=ddlsubgroup.ClientID%>').val() + '"}',
                 type: "POST",
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     PatientData = jQuery.parseJSON(result.d);
                     if (PatientData.length > 0) {
                         jQuery("#Save").show();
                     }
                     else
                         jQuery("#Save").hide();

                     var output = jQuery('#tb_InvestigationItems').parseTemplate(PatientData);
                     jQuery('#div_InvestigationItems').html(output);
                     jQuery('#tb_grdLabSearch tr:even').addClass("GridViewAltItemStyle");
                     jQuery('#div_InvestigationItems').html(output);
                     jQuery("#tb_grdLabSearch").tableDnD({
                         onDragClass: "GridViewDragItemStyle"
                     });
                     jQuery('#tb_grdLabSearch tr:even').addClass("GridViewAltItemStyle");
                 },
                 error: function (xhr, status) {
                     alert("Error ");
                 }
             });

         }
         function clearform() {
             jQuery("#tb_grdLabSearch").remove();
             jQuery('#<%=ddlSubCategory.ClientID%> option:nth-child(1)').attr('selected', 'selected');
         }
     </script>
<script type="text/javascript">
    function SearchDept() {
        jQuery.ajax({
            url: "Services/MapInvestigationObservation.asmx/GetDeptPriorty",
            data: '{}', 
            type: "POST", 	        
            contentType: "application/json; charset=utf-8",
            timeout: 120000,
            dataType: "json",
            success: function (result) {
                PatientData = "";
                PatientData = jQuery.parseJSON(result.d);
                if (PatientData.length > 0)
                    jQuery("#Save").show();
                else
                    jQuery("#Save").hide();

                var output = jQuery('#tb_InvestigationItems').parseTemplate(PatientData);
                jQuery('#div_InvestigationItems').html(output);
                jQuery('#div_InvestigationItems').html(output);
                jQuery("#tb_grdLabSearch").tableDnD({
                    onDragClass: "GridViewDragItemStyle"
                });
                jQuery('#tb_grdLabSearch tr:even').addClass("GridViewAltItemStyle");

            },
            error: function (xhr, status) {
                alert("Error ");
            }
        });
    }
    function Searchsubgroup() {
        jQuery.ajax({
            url: "Services/MapInvestigationObservation.asmx/Getsubgroupdept",
            data: '{SubCategoryId: "' + jQuery("#<%=ddlSubCategory.ClientID %>").val() + '"}',
            type: "POST",
            contentType: "application/json; charset=utf-8",
            timeout: 120000,
            dataType: "json",
            success: function (result) {
                PatientData = "";
                PatientData = jQuery.parseJSON(result.d);
                if (PatientData.length > 0)
                    jQuery("#Save").show();
                else
                    jQuery("#Save").hide();

                var output = jQuery('#tb_InvestigationItems').parseTemplate(PatientData);
                jQuery('#div_InvestigationItems').html(output);
                jQuery('#div_InvestigationItems').html(output);
                jQuery("#tb_grdLabSearch").tableDnD({
                    onDragClass: "GridViewDragItemStyle"
                });
                jQuery('#tb_grdLabSearch tr:even').addClass("GridViewAltItemStyle");

            },
            error: function (xhr, status) {
                alert("Error ");
            }
        });
    }
</script>
</asp:Content>

