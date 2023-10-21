<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" ClientIDMode="Static" CodeFile="InterfaceBooking.aspx.cs" Inherits="Design_Master_InterfaceBooking" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
	Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
<link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager AsyncPostBackErrorMessage="Error..." ID="ScriptManager1" EnablePageMethods="true" runat="server">
</Ajax:ScriptManager>
   <div class="POuter_Box_Inventory"  style="text-align:center;">
    <b>Interface Booking Data</b>
    </div>
         <div class="POuter_Box_Inventory">
                  <div class="row">
                       <div class="col-md-1"></div>
                      <div class="col-md-3" >
                          <label class="pull-left">Centre</label>
			               <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5">
                        <asp:ListBox ID="lstCentreLoadList" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
                         </div>
                      <div class="col-md-1"></div>
                      <div class="col-md-3" >
<label class="pull-left">
                            <asp:DropDownList ID="ddlSearchType" class="ddlSearchType  chosen-select"  runat="server">
                                <asp:ListItem Value="bd.WorkOrderID"  Selected="True">Work Order ID.</asp:ListItem>
                                <asp:ListItem Value="bd.Patient_ID">UHID No.</asp:ListItem>       
                                <asp:ListItem Value="bd.Barcodeno">Sin No.</asp:ListItem>                                             
                                <asp:ListItem Value="bd.PName">Patient Name</asp:ListItem>
                                <asp:ListItem Value="bd.Mobile">Mobile</asp:ListItem>
                         </asp:DropDownList></label>
			               <b class="pull-right">:</b>
                     </div>
                   
                     <div class="col-md-3">
                         <asp:TextBox ID="txtDataToSearch" runat="server"></asp:TextBox>
                         </div>
                 </div>
                 <div class="row">
                      <div class="col-md-1"></div>
                      <div class="col-md-3" >
                         <label class="pull-left">Interface Company</label>
			               <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-5" >
                         <asp:DropDownList ID="ddlCompany" runat="server" class="ddlCompany  chosen-select" >         
                               </asp:DropDownList>
                         </div>
                     <div class="col-md-1"></div>
                      <div class="col-md-3" style="text-align:right">
                          <label class="pull-left">Search Type</label>
			               <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-8" >
                         <asp:RadioButtonList ID="rblSearchType" runat="server" RepeatDirection="Horizontal"  onclick="hideTable()" >
                             <asp:ListItem Value="1" Text="Booked" ></asp:ListItem>
                             <asp:ListItem Value="0" Text="Pending"  ></asp:ListItem>
                             <asp:ListItem Value="-1" Text="Fail" ></asp:ListItem>
                             <asp:ListItem Value="2" Text="All" Selected="True"></asp:ListItem>
                         </asp:RadioButtonList>
                         </div>
                 </div>
                 <div class="row">
                      <div class="col-md-1"></div>
                     <div class="col-md-3" style="text-align:right">
                         <label class="pull-left">From Date</label>
			               <b class="pull-right">:</b>
                     </div>
                     <div class="col-md-2" >
                         <asp:TextBox ID="txtFromDate" runat="server" ></asp:TextBox>
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                     </div>
                     <div class="col-md-4"></div>
                     <div class="col-md-3" style="text-align:right">
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
            <button type="button" id="btnExport" onclick="Export()" style="display:none">Export to Excel</button>
        </div>
          <div class="POuter_Box_Inventory" style=" text-align: center;">
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
        function Export() {
            var CentreIDs = $('#lstCentreLoadList').multipleSelect("getSelects").join();
            if (CentreIDs == "") {
                toast("Error", 'Please Select Centre', "");
                return;
            }
            var SearchField = $('#<%=ddlSearchType.ClientID%>').val();
            var SearchData = $('#<%=txtDataToSearch.ClientID%>').val();
            serverCall('InterfaceBooking.aspx/searchInterface',
                                { fromDate: jQuery('#txtFromDate').val(), toDate: jQuery('#txtToDate').val(), CompanyName: jQuery('#ddlCompany option:selected').text(), SearchType: $('#rblSearchType input[type=radio]:checked').val(), Status: $('#rblSearchType input[type=radio]:checked').next().text(), IsSearch: "0", SearchField: SearchField, SearchData: SearchData, CentreIDs: CentreIDs, CompanyID: jQuery('#ddlCompany').val() },
                                function (result) {
                                    window.open('../common/ExportToExcel.aspx');
                                });


        }


        function getAllSelectedCentre() {
            var CentreID = '';
            var SelectedLaength = $('#lstCentreLoadList').multipleSelect("getSelects").join().split(',').length;
            for (var i = 0; i <= SelectedLaength - 1; i++) {
                CentreID += "'" + $('#lstCentreLoadList').multipleSelect("getSelects").join().split(',')[i] + "',";
            }
            return CentreID;
        }
        function Search() {
            var CentreIDs = $('#lstCentreLoadList').multipleSelect("getSelects").join();
            if (CentreIDs == "") {
                toast('Error', 'Please Select Centre', '');
                return;
            }
            jQuery('#btnSearch').attr('disabled', 'disabled').val('Searching...');
            var SearchField = $('#<%=ddlSearchType.ClientID%>').val();
            var SearchData = $('#<%=txtDataToSearch.ClientID%>').val();
            serverCall('InterfaceBooking.aspx/searchInterface',
                { fromDate: jQuery('#txtFromDate').val(), toDate: jQuery('#txtToDate').val(), CompanyName: jQuery('#ddlCompany option:selected').text(), SearchType: $('#rblSearchType input[type=radio]:checked').val(), Status: $('#rblSearchType input[type=radio]:checked').next().text(), IsSearch: "1", SearchField: SearchField, SearchData: SearchData, CentreIDs: CentreIDs, CompanyID: jQuery('#ddlCompany').val() },
                function (result) {
                    InterfaceData = $.parseJSON(result);
                    if (InterfaceData.length == 0) {
                        jQuery('#divInterface').html('');
                        jQuery('#divInterface,#btnExport').hide();

                    }
                    else {

                        var output = $('#tb_Interface').parseTemplate(InterfaceData);
                        jQuery('#divInterface').html(output);
                        jQuery('#divInterface,#btnExport').show();

                    }
                    $('#btnSearch').removeAttr('disabled').val('Search');
                })

        }
        function hideTable() {
            jQuery('#divInterface').html('');
            jQuery('#divInterface,#btnExport').hide();
        }
    </script>
    <script id="tb_Interface" type="text/html">
    <table  cellspacing="0" rules="all" border="1" id="tb_grdInterface"
    style="width:1260px;border-collapse:collapse;">
        <thead>
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Interface Client</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Type</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Doctor ID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Doctor Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Centre</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">WorkOrderID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:220px;">Patient Name</th>
           
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">UHID No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Mobile</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Gender</th>       
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Age</th>    
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Test Code</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:180px;">Item Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Sin No</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">HLM Patient Type</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:180px;">HLM OPD IPD No</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:180px;">Response</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Status</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">StagingTableDateTime</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">ITDoseReceivedDateTime</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">ITDoseBookedDateTime</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">ITDoseReceivedTimeDiffrence</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">ITDoseBookedTimeDiffrence</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">IsUrgent</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">AllowPrint</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Interface_BillNo</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;"></th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;"></th>
            
            
             <th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none"></th>
           
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
                    <td class="GridViewLabItemStyle"><#=j+1#>
                       
                    </td>
                    <td class="GridViewLabItemStyle" id="tdInterfaceClient" style="width:120px;"><#=objRow.InterfaceClient#></td>
                    <td class="GridViewLabItemStyle" id="tdType" style="width:60px;"><#=objRow.Type#></td>
                    <td class="GridViewLabItemStyle" id="td4" style="width:60px;"><#=objRow.Doctor_id#></td>
                    <td class="GridViewLabItemStyle" id="td5" style="width:60px;"><#=objRow.Doctorname#></td>
                    <td class="GridViewLabItemStyle" id="tdCentre" style="width:120px;"><#=objRow.Centre#></td>
                    <td class="GridViewLabItemStyle" id="tdWorkOrderID" style="width:120px;"><#=objRow.WorkOrderID#></td>
                    <td class="GridViewLabItemStyle" id="tdPName" style="width:220px;"><#=objRow.PatientName#></td>
                    <td class="GridViewLabItemStyle" id="tdPatient_ID" style="width:120px;"><#=objRow.UHIDNo#></td>                     
                    <td class="GridViewLabItemStyle" id="tdMobile" style="width:120px;"><#=objRow.Mobile#></td>
                    <td class="GridViewLabItemStyle" id="tdGender" style="width:80px;"><#=objRow.Gender#></td>
                    <td class="GridViewLabItemStyle" id="td8" style="width:120px;"><#=objRow.Age#></td>
                    <td class="GridViewLabItemStyle" id="tdItemId_Interface" style="width:120px;"><#=objRow.TestCode#></td>  
                    <td class="GridViewLabItemStyle" id="tdItemName_Interface" style="width:180px;"><#=objRow.TestName#></td> 
                    <td class="GridViewLabItemStyle" id="td3" style="width:120px;"><#=objRow.SinNo#></td> 
                    <td class="GridViewLabItemStyle" id="td9" style="width:120px;"><#=objRow.HLMPatientType#></td> 
                    <td class="GridViewLabItemStyle" id="td10" style="width:180px;"><#=objRow.HLMOPDIPDNo#></td> 
                    <td class="GridViewLabItemStyle" id="tdResponse" style="width:180px;"><#=objRow.Response#></td> 
                    <td class="GridViewLabItemStyle" id="tdStatus" style="width:60px;"><#=objRow.Status#></td> 
                    <td class="GridViewLabItemStyle"  style="width:60px;"><#=objRow.StagingTableDateTime#></td> 
                    <td class="GridViewLabItemStyle"  style="width:60px;"><#=objRow.ITDoseReceivedDateTime#></td> 
                    <td class="GridViewLabItemStyle"  style="width:60px;"><#=objRow.ITDoseBookedDateTime#></td> 
                    <td class="GridViewLabItemStyle"  style="width:60px;"><#=objRow.ITDoseReceivedTimeDiffrence#></td> 
                    <td class="GridViewLabItemStyle"  style="width:60px;"><#=objRow.ITDoseBookedTimeDiffrence#></td> 
                    <td class="GridViewLabItemStyle"  style="width:60px;"><#=objRow.isurgent#></td> 
                    <td class="GridViewLabItemStyle"  style="width:60px;"><#=objRow.AllowPrint#></td>
                    <td class="GridViewLabItemStyle" id="tdInterface_BillNo" style="width:60px;text-align: left;"><#=objRow.Interface_BillNo#></td> 
                    <td class="GridViewLabItemStyle" id="td1" style="width:120px;">
                           <#
                           if(objRow.IsBooked=="-1" && objRow.ItemID_AsItdose==0){#>                         
                           <input type="button" id="btnItem" class="ItDoseButton" value="ItemMapping" onclick="ItemMapping(this)" />
                            <#}
                            #>
                           </td>
                         <td class="GridViewLabItemStyle" id="td2" style="width:120px;">
                             <#
                           if(objRow.IsBooked=="-1" || objRow.Response.indexOf('MySQL') > -1){#>
                              <input type="button" id="btnResend" class="ItDoseButton"  value="Resend" onclick="ResendData(this)"/>
                               <#}
                            #>
                           </td>
                        
                       <td class="GridViewLabItemStyle" id="tdID" style="width:120px;display:none"><#=objRow.ID#></td>  
                    
                       
                    </tr>
        <#}
        #>       
     </table>
    </script>
    
     <script type="text/javascript">
         function ItemMapping(rowID) {
             var ID = $(rowID).closest('tr').find('#tdID').text();
             serverCall('InterfaceBooking.aspx/encryptID', { ID: ID },
               function (result) {
                   window.open('ItemMasterInterface.aspx?ID=' + result);
               });

         }
         function ResendData(rowID) {
             jQuery(rowID).closest('tr').find("#btnResend").val('Resending...').attr('disabled', 'disabled');
             var ID = $(rowID).closest('tr').find('#tdID').text();
             serverCall('InterfaceBooking.aspx/resendInterface', { ID: ID },
                 function (result) {
                     resendData = result;
                     if (resendData == "1") {
                         toast('Success', 'Resend Successfully');
                         jQuery(rowID).closest('tr').find("#btnResend").hide();
                         jQuery(rowID).closest('tr').find("#btnResend").val('Resend').removeAttr('disabled');
                     }
                     else {
                         toast('Error', 'Error to Resend Data');
                     }
                 })
         }
              </script>

    <script type="text/javascript" >
        jQuery(function () {
            jQuery('#txtFromDate').change(function () {
                ChkDate();
            });
            jQuery('#txtToDate').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {
            serverCall('InterfaceBooking.aspx/compareDate',
                { fromDate: jQuery('#txtFromDate').val(), toDate: jQuery('#txtToDate').val() },
                function (mydata) {
                    var data = mydata;
                    if (data == false) {
                        toast('Error', 'Difference between From Date and To Date Can not Greater then 3 Days');
                        jQuery('#btnSearch').attr('disabled', 'disabled');
                    }
                    else {
                        jQuery('#btnSearch').removeAttr('disabled');
                    }
                })
        }
         </script>
    <script type="text/javascript">
        $(function () {
            $('[id*=lstCentreLoadList]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            bindInstaCentre();
        });
        function bindInstaCentre() {
            jQuery('#<%=lstCentreLoadList.ClientID%> option').remove();
            serverCall('InterfaceBooking.aspx/bindInstaCentre', {},
                function (result) {
                    CentreLoadListData = jQuery.parseJSON(result);
                    for (i = 0; i < CentreLoadListData.length; i++) {
                        jQuery("#lstCentreLoadList").append(jQuery("<option></option>").val(CentreLoadListData[i].CentreID).html(CentreLoadListData[i].Interface_CentreName));
                    }
                    jQuery('[id*=lstCentreLoadList]').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                    jQuery('[id*=lstCentreLoadList]').multipleSelect("checkAll");
                })
        }
    </script>
    
</asp:Content>

