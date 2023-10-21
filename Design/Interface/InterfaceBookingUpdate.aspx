<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" ClientIDMode="Static" CodeFile="InterfaceBookingUpdate.aspx.cs" Inherits="Design_Master_InterfaceBookingUpdate" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
<link href="../../App_Style/multiple-select.css" rel="stylesheet" />

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager AsyncPostBackErrorMessage="Error..." ID="ScriptManager1" EnablePageMethods="true" runat="server">
</Ajax:ScriptManager>
       
   <div class="POuter_Box_Inventory"  style="text-align:center">
    <b>Interface Booking Update</b><br />
      <asp:Label ID="lblErrorMsg" runat="server" class="ItDoseLblError"></asp:Label>
       </div>
         <div class="POuter_Box_Inventory"  style="text-align:center;">
                  <div class="row">
                       <div class="col-md-1"></div>
                      <div class="col-md-3">
                          <label class="pull-left">Type Of Operation</label>
			               <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5" >
                     <asp:RadioButtonList ID="rdoOperationType" runat="server" RepeatDirection="Horizontal"  onclick="hideTable();bindSearchType()" >
                             <asp:ListItem Value="Visit Details" Text="Visit Details" Selected="True" ></asp:ListItem>
                             <asp:ListItem Value="Patient Details" Text="Patient Details"  ></asp:ListItem>                          
                         </asp:RadioButtonList>
                         </div>
                      <div class="col-md-1"></div>
                      <div class="col-md-3" >
                         <label class="pull-left">
                         <asp:DropDownList ID="ddlSearchType" class="ddlSearchType  chosen-select"  runat="server" Width="140px">
                                              
                         </asp:DropDownList></label>
			               <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5" >
                         <asp:TextBox ID="txtDataToSearch" runat="server"></asp:TextBox>
                         </div>
                 </div>
                 <div class="row">
                     <div class="col-md-1"></div>
                      <div class="col-md-3">
                          <label class="pull-left">Interface Company</label>
			               <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5" >
                         <asp:DropDownList ID="ddlCompany" runat="server" class="ddlCompany  chosen-select"> </asp:DropDownList>
                     </div>
                     <div class="col-md-1"></div>
                      <div class="col-md-3" >
                          <label class="pull-left">Search Type </label>
			               <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                         <asp:RadioButtonList ID="rblSearchType" runat="server" RepeatDirection="Horizontal"  onclick="hideTable()" >
                             <asp:ListItem Value="1" Text="Updated" ></asp:ListItem>
                             <asp:ListItem Value="0" Text="Pending"  ></asp:ListItem>
                             <asp:ListItem Value="-1" Text="Fail" ></asp:ListItem>
                             <asp:ListItem Value="2" Text="All" Selected="True"></asp:ListItem>
                         </asp:RadioButtonList>
                         </div>
                 </div>
                 <div class="row">
                     <div class="col-md-1"></div>
                     <div class="col-md-3" >
                         <label class="pull-left">From Date </label>
			               <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-2" >
                         <asp:TextBox ID="txtFromDate" runat="server"></asp:TextBox>
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                     </div>
                      <div class="col-md-4"></div>
                     <div class="col-md-3">
                         <label class="pull-left">To Date</label>
			               <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-2" >
                         <asp:TextBox ID="txtToDate" runat="server" ></asp:TextBox>
                         <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                     </div>
                 </div>
             </div>
         <div class="POuter_Box_Inventory" style="text-align: center;">
            <button type="button" id="btnSearch" onclick="Search()" >Search</button>
        </div>
          <div class="POuter_Box_Inventory" style="text-align: center;">
           <div id="divInterface" style="max-height: 320px; overflow-y: auto; overflow-x: auto;">
                                        
            </div>
           </div>
        </div>
     <script type="text/javascript">
         jQuery(function () {
             var config = {
                 '.chosen-select': {},
                 '.chosen-select-deselect': { allow_single_deselect: true },
                 '.chosen-select-no-single': { disable_search_threshold: 10 },
                 '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                 '.chosen-select-width': { width: "95%" }
             }
             for (var selector in config) {
                 jQuery(selector).chosen(config[selector]);
             }


         });
         </script> 

    <script type="text/javascript"> 
        function Search() {
            var fromDate = jQuery('#txtFromDate').val();
            var toDate = jQuery('#txtToDate').val();
            var CompanyName = $('#<%=ddlCompany.ClientID%> option:selected').text();
            var SearchType = $('#rblSearchType input[type=radio]:checked').val();          
            var TypeOfOperation = $('#rdoOperationType input[type=radio]:checked').val();
            var SearchField = $('#<%=ddlSearchType.ClientID%>').val();
            var SearchData = $('#<%=txtDataToSearch.ClientID%>').val();  
            jQuery('#divInterface').html('');
            jQuery('#btnSearch').attr('disabled', 'disabled').val('Searching...');
            serverCall('InterfaceBookingUpdate.aspx/searchInterface',
                { fromDate: fromDate, toDate: toDate, CompanyName: CompanyName, SearchType: SearchType, TypeOfOperation: TypeOfOperation, SearchField: SearchField, SearchData: SearchData, CompanyID: $('#<%=ddlCompany.ClientID%>').val() },
                function (result) {
                    InterfaceData = $.parseJSON(result);
                    if (InterfaceData.length == 0) {
                        jQuery('#divInterface').html('');
                        jQuery('#divInterface').hide();
                        toast('Info', 'No Record Found');
                    }
                    else {
                        var output = $('#tb_Interface').parseTemplate(InterfaceData);
                        jQuery('#divInterface').html(output);
                        jQuery('#divInterface').show();

                    }
                    $('#btnSearch').removeAttr('disabled').val('Search');
                   
                })
        }
        function hideTable() {
            jQuery('#divInterface').html('');
            jQuery('#divInterface,#btnExport').hide();
        }
        jQuery(function () {
            bindSearchType();
        });
        function bindSearchType() {
            jQuery("#ddlSearchType option").remove();
            jQuery("#ddlSearchType").trigger('chosen:updated');
            if (jQuery("#rdoOperationType input[type=radio]:checked").val() == "Visit Details") {
                jQuery("#ddlSearchType").append($("<option></option>").val("Work Order ID").html("Work Order ID."));
                jQuery("#ddlSearchType").append($("<option></option>").val("UHID No").html("UHID No."));
            }
            else {
                jQuery("#ddlSearchType").append($("<option></option>").val("UHID No").html("UHID No."));
            }
            jQuery("#ddlSearchType").prop('selectedIndex', 0);
            jQuery("#ddlSearchType").trigger('chosen:updated');
        }
    </script>
    <script id="tb_Interface" type="text/html">
    <table  cellspacing="0" rules="all" border="1" id="tb_grdInterface"
    style="width:1260px;border-collapse:collapse;">
        <thead>
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Interface Client</th>           
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">WorkOrderID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:220px;">Patient Name</th>           
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">UHID No.</th>           
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Gender</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Age</th>
             <th class="GridViewHeaderStyle" scope="col" style="width:80px;">DOB</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">TPA Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Corporate ID Card</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:180px;">Response</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Status</th>   
             <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Action</th>             
		</tr>
             </thead>
        <#
        var dataLength=InterfaceData.length;
       
        var objRow;           
        for(var j=0;j<dataLength;j++)
        {
        objRow = InterfaceData[j];
        #>
                    <tr id="<#=j+1#>" >
                    <td class="GridViewLabItemStyle"><#=j+1#></td>
                    <td class="GridViewLabItemStyle"><#=objRow.InterfaceClient#></td>
                     <td class="GridViewLabItemStyle"><#=objRow.WorkOrderID#></td>
                        <td class="GridViewLabItemStyle"><#=objRow.PatientName#></td>
                        <td class="GridViewLabItemStyle"><#=objRow.UHIDNo#></td>
                        <td class="GridViewLabItemStyle"><#=objRow.Gender#></td>
                        <td class="GridViewLabItemStyle"><#=objRow.Age#></td>
                        <td class="GridViewLabItemStyle"><#=objRow.DOB#></td>
                        <td class="GridViewLabItemStyle"><#=objRow.TPAName#></td>
                        <td class="GridViewLabItemStyle"><#=objRow.CorporateIDCard#></td>
                        <td class="GridViewLabItemStyle"><#=objRow.Response#></td>
                        <td class="GridViewLabItemStyle"><#=objRow.STATUS#></td>
                        <td class="GridViewLabItemStyle">
                          <#if(objRow.IsUpdated=='-1'){#>
                          <input type="button" value="ReSend" onclick="ResendData('<#=objRow.ID#>', '<#=objRow.TableName#>')"
                              <#}#>
                        </td>
                    </tr>
        <#}
        #>       
     </table>
    </script>
    
     <script type="text/javascript">         
         function ResendData(ID, TableName) {
             serverCall('InterfaceBookingUpdate.aspx/resendInterface', { ID: ID, TableName: TableName },
                 function (result) {
                     resendData = result;
                     if (resendData == "1") {
                         toast('Success', 'Resend Successfully');
                         Search();
                     }
                     else {
                         toast('Error', 'Error to Resend Data');
                     }
                 })
         }
              </script>
</asp:Content>

