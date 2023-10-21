<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Invoice_Creation.aspx.cs" ClientIDMode="Static" EnableEventValidation="false" Inherits="Design_Master_Invoice_Creation" MasterPageFile="~/Design/DefaultHome.master" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/UserControl/PanelGroup.ascx" TagPrefix="uc1" TagName="PanelGroup" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
        <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
       <%: Scripts.Render("~/bundles/Chosen") %>
       <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
       <link href="../../App_Style/multiple-select.css" rel="stylesheet"/>
<style type="text/css">
    .multiselect {
        width: 100%;
    }
</style>  
 <script type="text/javascript">
    
         jQuery(function () {
             jQuery('[id*=lstPanel]').multipleSelect({
                 includeSelectAllOption: true,
                 filter: true, keepOpen: false
             });
         });


         </script>  
  <div id="Pbody_box_inventory" >
      <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
           <Services>
               <Ajax:ServiceReference Path="../Common/Services/CommonServices.asmx" />
               <Ajax:ServiceReference Path="Services/Panel_Invoice.asmx" />
           </Services>
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">           
                <b>Create New Invoice</b>                             
               <asp:TextBox ID="lblInvoiceNo" runat="server" style="display:none" />  
             <div class="row"  style="text-align:center">
                 <div class="col-md-3"></div>
                 <div class="col-md-3"><label class="pull-left"> Billing Cycle </label> <b class="pull-right">:</b></div>
                 <div class="col-md-2"><asp:DropDownList ID="ddlInvoiceBillingCycle" runat="server">
                     <asp:ListItem Text="All" Value="0" Selected="True"></asp:ListItem>
                                    <asp:ListItem Text="Weekly" Value="Weekly"></asp:ListItem>
                                    <asp:ListItem Text="15 Days" Value="15 Days"></asp:ListItem>
                                    <asp:ListItem Text="Monthly" Value="Monthly" ></asp:ListItem>
                                </asp:DropDownList></div>
                <%-- <div class="col-md-2"> </div>--%>
                <div class="col-md-14">

                    <%--<div><input id="chkAll" type="checkbox" name="ALL" value="ALL" style="text-align:center;" onchange="chkradio()"/>ALL</div>--%>


     <uc1:PanelGroup runat="server" ID="rblSearchType"  ClientIDMode="Static" />
                     </div>
                  </div>                                
         </div>
        <div  id="SearchDiv" class="POuter_Box_Inventory" >
             <div class="row">
                 <div class="col-md-3">
                     </div>
                <div class="col-md-3">
                    <label class="pull-left">From Date</label>
                    <b class="pull-right">:</b>
                    </div>
                 <div class="col-md-2">
                     <asp:TextBox ID="dtFrom" runat="server" ></asp:TextBox>
                     <cc1:CalendarExtender runat="server" ID="calFromDate" TargetControlID="dtFrom" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                     </div>
                <div class="col-md-5">
                     </div>
                 <div class="col-md-2">
                       <label class="pull-left">To Date</label>
                    <b class="pull-right">:</b>
                    </div>

                  <div class="col-md-3">
                      <asp:Label ID="lblBalAmt" runat="server" Text="0" Visible="False"></asp:Label>
                      <asp:TextBox ID="dtTo" runat="server" Width="100px" ></asp:TextBox>
                      <cc1:CalendarExtender runat="server" ID="calToDate" TargetControlID="dtTo" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                      </div>
                 </div>

               <div class="row">
                    <div class="col-md-3">
                     </div>
                <div class="col-md-3">
                    <label class="pull-left">Business Zone</label>
                    <b class="pull-right">:</b>
                    </div>
                 <div class="col-md-5">
                     <asp:DropDownList ID="ddlBusinessZone" runat="server" onchange="bindState()" class="ddlBusinessZone chosen-select">
                        </asp:DropDownList>
                     </div>
                   <div class="col-md-2">
                       </div>
                   <div class="col-md-2">
                    <label class="pull-left">State</label>
                    <b class="pull-right">:</b>
                    </div>
                 <div class="col-md-5">
                     <asp:DropDownList ID="ddlState" runat="server" onchange="bindPanel()"  class="ddlState chosen-select">
                            </asp:DropDownList>
                     </div>
                   </div>

            <div class="row">
                 <div class="col-md-3">
                     </div>
                <div class="col-md-3">
                    <label class="pull-left">Client Name</label>
                    <b class="pull-right">:</b>
                    </div>
                 <div class="col-md-5">
                      <asp:ListBox ID="lstPanel" runat="server" CssClass="multiselect" SelectionMode="Multiple" ></asp:ListBox>
                     </div>
                 </div>
            <div class="row">
                 <div class="col-md-3">
                     </div>
                <div class="col-md-3">
                    <label class="pull-left">Invoice Date</label>
                    <b class="pull-right">:</b>
                    </div>
                 <div class="col-md-3">
                     <asp:TextBox ID="txtInvoiceDate" runat="server" OnTextChanged="txtInvoiceDate_TextChanged" AutoPostBack="false" Width="100px" ></asp:TextBox>
<cc1:CalendarExtender runat="server" ID="calInvoiceDate" TargetControlID="txtInvoiceDate"  Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                     </div>
                 </div>
            </div>
             <div  class="POuter_Box_Inventory"  style="text-align:center">
                 <input id="btnSearch" type="button" value="Search"  class="searchbutton"  onclick="InvoiceSearch()" />
                 <input id="btnSave" type="button" value="Save"  class="searchbutton" style="display:none" onclick="saveInvoice()" />
                 <input id="btnCancel" type="button" value="Cancel"  class="searchbutton"  onclick="cancelControl()" />
                 </div>

            
             <div class="POuter_Box_Inventory" >
            <div class="Purchaseheader">
                Search Result
            </div>          
           <div id="div_Data" style="max-height:350px; overflow:auto;">
              </div>  
               
       <div id="labResultData"  style="max-height:350px; overflow:auto;" >
 </div>
        </div> 
      </div>                                          
  <script id="tb_InvestigationItems" type="text/html">
   <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch" 
    style="border-collapse:collapse;width:100%">
		<tr id="Tr1">
		    <th class="GridViewHeaderStyle" scope="col" style="width:20px">View</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:20px;">S.No.</th>	
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">Code</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:450px;">Client Name</th>			
			<th class="GridViewHeaderStyle" scope="col">Share&nbsp;Amt.</th>		
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">TDS
                <input id="chkTDSHeader" type="checkbox"  onclick='chkTDSAll();' />
            </th>	
            <th class="GridViewHeaderStyle" scope="col" style="display:none">Paid&nbsp;To&nbsp;Client
                <input id="chkPaidClientHeader" type="checkbox"  onclick='chkPaidClient();' />
            </th>	            			
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;"> 
			<input id="chkHeader" type="checkbox"  onclick='chkall();' />
			</th>
		</tr>
       <#           
              var dataLength=InvoiceData.length;
              var objRow;               
             for(var j=0;j<dataLength;j++)
               {                                    
                  objRow = InvoiceData[j];
                  chkallAmt=Number(chkallAmt)+Number(InvoiceData[j].NetAmount);       
            #>
<tr id="<#=j+1#>" >                              
<td class="GridViewLabItemStyle" style="text-align:center">
    <img id="imgSelectPRO" src="../../App_Images/view.gif" style="cursor:pointer;" onclick="loadPanelDetail('<#=objRow.Panel_ID #>',selectedlabno_<#=j+1#>,'<#=objRow.SearchType#>','<#=objRow.fromDate#>','<#=objRow.toDate#>','<#=objRow.SearchTypeID#>','<#=objRow.PatientPayTo#>','<#=objRow.Payment_Mode#>');"/>
    <img id="img1" src="../../App_Images/excelexport.gif" style="cursor:pointer;" onclick="ExcelDetail('<#=objRow.Panel_ID #>',selectedlabno_<#=j+1#>,'<#=objRow.SearchType#>','<#=objRow.fromDate#>','<#=objRow.toDate#>','<#=objRow.SearchTypeID#>','<#=objRow.PatientPayTo#>','<#=objRow.Payment_Mode#>');"/>
</td>
<td class="GridViewLabItemStyle" ><#=j+1#><input type="hidden" id="Alllabno_<#=j+1#>" />
                <input type="hidden" id="selectedlabno_<#=j+1#>" /></td>

    <td id="tdPanel_Code"  class="GridViewLabItemStyle" ><#=objRow.Panel_Code#></td>
    <td id="PanelName"  class="GridViewLabItemStyle" ><#=objRow.PanelName#>
       <input type="hidden" id="Panel_ID" value="<#=objRow.Panel_ID#>"/>
       <input type="hidden" id="LabNO" value="<#=objRow.LedgerTransactionID#>"/></td>
    <td id="tdSearchType"  class="GridViewLabItemStyle" style="display:none"><#=objRow.SearchType#></td>
    <td id="tdSearchTypeID"  class="GridViewLabItemStyle" style="display:none"><#=objRow.SearchTypeID#></td>
    <td id="td_PatientPayTo"  class="GridViewLabItemStyle" style="display:none"><#=objRow.PatientPayTo#></td>
    <td id="tdPayment_Mode"  class="GridViewLabItemStyle" style="display:none"><#=objRow.Payment_Mode#></td>
    
    <td id="tdShareAmt"  class="GridViewLabItemStyle" style="text-align:right"><#=objRow.ShareAmt#></td>
   
    <td class="GridViewLabItemStyle" style="width:10px;"><input id="chk" type="checkbox" checked="checked" class="chkAllHeader" /></td>
    <td class="GridViewLabItemStyle" style="width:10px;display:none" id="tdFromDate"><#=objRow.fromDate#></td>
    <td class="GridViewLabItemStyle" style="width:10px;display:none" id="tdToDate"><#=objRow.toDate#></td>
</tr>

            <#}#>

     </table>     
    </script>
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
               $(selector).chosen(config[selector]);
           }
           
           jQuery('#ddlBusinessZone').trigger('chosen:updated');
           bindState();
       });
   </script>
  <script id="sc_PatientDetail" type="text/html">
   <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_labnumberresult"
    style="border-collapse:collapse;width:100%">
         <thead>
		<tr id="Header">
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:80px">Reg.&nbsp;Date</th>
		    <th class="GridViewHeaderStyle" scope="col" style="width:20px">Lab No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:360px;">Test Description</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:180px;">Patient Name</th>	
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">Age/Gender</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Gross Amt.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Dis. Amt.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Net Amt.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;display:none">Paid Amt.</th>
			<#
            if($("#rblSearchType input[type=radio]:checked").val()=="1")
            {#>           
            <th class="GridViewHeaderStyle" scope="col">Normal Price</th>
            <th class="GridViewHeaderStyle" scope="col">Net Price</th>
            <th class="GridViewHeaderStyle" scope="col">Client Share</th>
            <#}
             #>
            <#
             if(($("#rblSearchType input[type=radio]:checked").val()=="9"))
            {#>          
            <th class="GridViewHeaderStyle" scope="col">Invoice Amt.</th>
            <#}           
             #>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;display:none;"> 
			<input type="checkbox" id="chklabresultheader" onclick='ckhalldetail();'/></th>			
</tr>
       </thead>
         <tbody>
       <#                  
              var dataLength=ObsTable.length;
              window.status="Total Records Found :"+ dataLength;
              if(_EndIndex>dataLength)
            {           
               _EndIndex=dataLength;
            }            
        for(var i=_StartIndex;i<_EndIndex;i++)
            {                         
                var  objRow = ObsTable[i];   
            #>
<tr id="<#=objRow.Panel_ID#>" 
    <#if(objRow.PCCSpecialFlag=="1"){#>
    
    style="background-color:coral"
    <#}
    
    #>        
     >
    <td class="GridViewLabItemStyle"><#=i+1#></td>
    <td class="GridViewLabItemStyle" id="TdRegdate"><#=objRow.RegDate#></td>
<td class="GridViewLabItemStyle" id="LedgerTransactionNo"><#=objRow.LedgerTransactionNo#></td>
    <td class="GridViewLabItemStyle"  style="width:150px;"><#=objRow.ItemName#></td>
<td class="GridViewLabItemStyle" id="PName"><#=objRow.PName#></td>
<td id="Age"  class="GridViewLabItemStyle" style="width:90px"><#=objRow.Age#> </td>
<td id="GrossAmount1"  class="GridViewLabItemStyle" style="width:50px;text-align:right"><#=objRow.Rate#></td>
<td id="DiscountOnTotal1"  class="GridViewLabItemStyle" style="width:50px;text-align:right"><#=objRow.Discount#> </td>
<td id="NetAmount1"  class="GridViewLabItemStyle" style="width:50px;text-align:right"><#=objRow.Amount#></td>
<td id="PaidAmt"  class="GridViewLabItemStyle" style="width:50px;text-align:right;display:none"><#=objRow.PaidAmt#></td>
    <#
            if($("#rblSearchType input[type=radio]:checked").val()=="1")
            {#>
    <td id="SuperShareAmt"  class="GridViewLabItemStyle" style="width:50px;text-align:right"><#=objRow.SuperShare#> </td>
     <td id="NormalShare"  class="GridViewLabItemStyle" style="width:50px;text-align:right"><#=objRow.NormalShare#> </td>
    <td id="ClientShare"  class="GridViewLabItemStyle" style="width:50px;text-align:right"><#=objRow.ClientShare#> </td>
     <#}        
        #>
    <#
            if(($("#rblSearchType input[type=radio]:checked").val()=="9") )
            {#>
    <td id="tdPCCInvoiceAmt"  class="GridViewLabItemStyle" style="width:50px;text-align:right"><#=objRow.PCCInvoiceAmt#> </td>
     
     <#}               
        #>
<td id="PName1" class="GridViewLabItemStyle" style="width:50px;display:none;"><input type="checkbox" id="chklabresult_<#=j+1#>"/></td>
</tr>
              <#}        
        #>
            </tbody>      
     </table>  
    <table id="tablePatientCount" style="border-collapse:collapse;">
       <tr>
   <# if(dataLength>50) {
           
     for(var j=0;j<_PageCount;j++){ #>
     <td class="GridViewLabItemStyle" style="width:8px;"><a href="javascript:void(0);" onclick="showPage('<#=j#>');" ><#=j+1#></a></td>
     <#}         
   }#>
     </tr>    
     </table>  
    </script>
       <script type="text/javascript">
           jQuery(function () {
               jQuery('[id*=lstPanel]').multipleSelect({
                   includeSelectAllOption: true,
                   filter: true, keepOpen: false
               });
           });
         </script>     
    <script type="text/javascript">      
        function saveInvoice() {          
            var chkCount = 0;
            var data = ""; var SearchType = ""; var fromDate = ""; var toDate = ""; var SearchTypeID = "", PatientPayTo = "", Payment_Mode = "";
            var Panel_ID = new Array();
            jQuery("#tb_grdLabSearch tr").closest('tr').find('#chk').filter(':checked').each(function () {
                chkCount += 1;
                SearchType = jQuery(this).closest('tr').find("#tdSearchType").text();
                SearchTypeID = jQuery(this).closest('tr').find("#tdSearchTypeID").text();
                PatientPayTo = jQuery(this).closest('tr').find("#td_PatientPayTo").text();
                Payment_Mode = jQuery(this).closest('tr').find("#tdPayment_Mode").text();
                fromDate = jQuery(this).closest('tr').find("#tdFromDate").text();
                toDate = jQuery(this).closest('tr').find("#tdToDate").text();         
                Panel_ID.push(jQuery(this).closest('tr').find("#Panel_ID").val());
               
            });

            if (chkCount == 0) {
                toast('Error',"Please Select Client");
                jQuery("#btnSave").attr('disabled', false);
                return;
            }                     
            serverCall('Invoice_Creation.aspx/SaveInvoice', { data: Panel_ID.join(), InvoiceDate: jQuery("#<%=txtInvoiceDate.ClientID %>").val(), fromDate: fromDate, toDate: toDate, SearchType: SearchType, SearchTypeID: SearchTypeID, PatientPayTo: PatientPayTo, PaymentMode: Payment_Mode }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast('Success',$responseData.response);
                    jQuery('#div_Data').html('');
                    jQuery('#div_Data,#btnSave').hide();
                    jQuery("#labResultData").hide();
                    jQuery("#btnSave").attr('disabled', false);
                    jQuery("#<%=lblInvoiceNo.ClientID%>").val(response);
                }                
                else {
                    toast('Error', $responseData.response);
                }
            });           
        }
</script>   
    <script type="text/javascript">
        jQuery(function () {
            jQuery("#tb_grdLabSearch :text").hide();
        });
        var chkallAmt = "0";
        function chkall() {
            if (jQuery("#chkHeader").is(':checked')) {
                jQuery(".chkAllHeader").prop('checked', 'checked');
            }
            else {
                jQuery(".chkAllHeader").prop('checked', false);
            }
        }
        function chkTDSAll() {
            if (jQuery("#chkTDSHeader").is(':checked')) {
                jQuery(".chkAllTDS").prop('checked', 'checked');
            }
            else {
                jQuery(".chkAllTDS").prop('checked', false);
            }
        }
        function chkPaidClient() {
            if (jQuery("#chkPaidClientHeader").is(':checked')) {
                jQuery(".chkAllPaidToClient").prop('checked', 'checked');
            }
            else {
                jQuery(".chkAllPaidToClient").prop('checked', false);
            }
        }
        function ckhalldetail() {
            if (jQuery("#chklabresultheader").is(':checked')) {
                jQuery("#tb_labnumberresult :checkbox").prop('checked', 'checked');
            }
            else {
                jQuery("#tb_labnumberresult :checkbox").prop('checked', false);
            }
        }
</script> 
    <script type="text/javascript">
        function getsumfromlabresultdata(id) {
            var sum = 0;
            jQuery("#labResultData").find("input[id^='chklabresult']:checked").each(function () {
                if ($(this).is(":checked") == true) {
                    var tr = $(this).closest("tr");
                    jQuery(tr).find("td#" + id).each(function () {
                        sum = sum + parseInt($(this).text());
                    });
                }
            });
            return sum;
        }
        function displaysumlabresultdata(displayid, sum) {
            jQuery("#" + displayid).html(sum);
        }                           
        var _PageSize = 50;
        var _PageNo = 0;
        var _PageCount = 0; var _StartIndex = 0; var _EndIndex = 0;
        function loadPanelDetail(Panel_ID, selectedlabnoid, SearchType, fromDate, toDate, SearchTypeID, PatientPayTo, Payment_Mode) {            
            serverCall('Invoice_Creation.aspx/SearchInvoicePatient', { Panel_ID: Panel_ID, SearchType: SearchType , fromDate: fromDate , toDate: toDate, SearchTypeID: SearchTypeID , PatientPayTo: PatientPayTo, PaymentMode: Payment_Mode }, function (response) {
                ObsTable = jQuery.parseJSON(response);
                _PageCount = Math.ceil(ObsTable.length / _PageSize);
                showPage('0');
            });            
        }
        function ExcelDetail(Panel_ID, selectedlabnoid, SearchType, fromDate, toDate, SearchTypeID, PatientPayTo, Payment_Mode) {
            serverCall('Invoice_Creation.aspx/ExcelDetail', { Panel_ID: Panel_ID, SearchType: SearchType, fromDate: fromDate, toDate: toDate, SearchTypeID: SearchTypeID, PatientPayTo: PatientPayTo, PaymentMode: Payment_Mode }, function (response) {
                
                if (response == 1) {
                    window.open('../common/ExportToExcel.aspx');
                }
                else if (response == 0) {
                    toast("Info", 'No Record Found!!', "");
                }
                
                else {
                    toast('Error', 'Error', '');
                }
            });
        }
        function showPage(_strPage, LedgerTransactionID, selectedlabnoid) {
            _StartIndex = (_strPage * _PageSize);
            _EndIndex = eval(eval(_strPage) + 1) * _PageSize;
            var output = jQuery('#sc_PatientDetail').parseTemplate(ObsTable);
            jQuery("#labResultData").html(output);
            jQuery("#labResultData").show();           
        }
</script>

    <script type="text/javascript">        
        var InvoiceData = "";
        var isHold = "0";
        var InvoiceNo = "";
        function InvoiceSearch() {
            jQuery('#div_Data').html('');
            jQuery('#labResultData').html('');
            if (jQuery("#lstPanel :selected").length == 0) {
                toast('Error', 'Please Select Client Name');
                return;
            }
            var PanelID = jQuery('#lstPanel').multipleSelect("getSelects").join();
            var type = "ALL";
            chkallAmt = "0";
            serverCall('Invoice_Creation.aspx/SearchInvoice', { dtFrom: jQuery("#<%=dtFrom.ClientID %>").val(), dtTo: jQuery("#<%=dtTo.ClientID %>").val(), PanelID: PanelID, type: type, InvoiceDate: $("#<%=txtInvoiceDate.ClientID %>").val(), SearchType: jQuery("#rblSearchType input[type=radio]:checked").next().text(), SearchTypeID: jQuery("#rblSearchType input[type=radio]:checked").val() }, function (response) {
                jQuery('#div_Data,#btnSave').hide();
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    InvoiceData = jQuery.parseJSON($responseData.response);
                    var output = jQuery('#tb_InvestigationItems').parseTemplate(InvoiceData);
                    jQuery('#div_Data,#btnSave').show();
                    jQuery('#div_Data').html(output);
                }
                else {
                    toast("Error", $responseData.response);
                }

            });
        };
</script>
    <script type="text/javascript">
        function bindBusinessZone() {
		jQuery("#ddlState option").remove();
		jQuery("#ddlBusinessZone option").remove();
            jQuery("#ddlState option").remove();
            jQuery('#<%=lstPanel.ClientID%> option').remove();
            jQuery('#lstPanel').multipleSelect("refresh");
               var $ddlState = jQuery('#ddlBusinessZone');
 
            serverCall('../Common/Services/CommonServices.asmx/bindBusinessZone', { }, function (response) {
               // if (con == 0)
                    $ddlState.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'State', isSearchAble: true, selectedValue: '0' });
                //else
                  //  $ddlState.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'State', isSearchAble: true });

               // callback($ddlState.val());
            });
            
        }
		function onSucessZone(result) {
            var stateData = jQuery.parseJSON(result);
           // jQuery("#ddlBusinessZone").append(jQuery("<option></option>").val("0").html("Select an Option"));
            if (stateData.length > 0) {
                jQuery("#ddlBusinessZone").append(jQuery("<option></option>").val("0").html("All"));
            }
            for (i = 0; i < stateData.length; i++) {
                jQuery("#ddlBusinessZone").append(jQuery("<option></option>").val(stateData[i].BusinessZoneID).html(stateData[i].BusinessZoneName));
            }
            $($('#ddlBusinessZone option').filter(function () { return this.text == "All" })[0]).prop('selected', true)


        }
            function onFailureZone() {

            } 
		function bindState() {
            jQuery("#ddlState option").remove();
            jQuery('#<%=lstPanel.ClientID%> option').remove();
            jQuery('#lstPanel').multipleSelect("refresh");
          //  if (jQuery("#ddlBusinessZone").val() != 0) {
                CommonServices.bindState(0, jQuery("#ddlBusinessZone").val(), onSucessState, onFailureState);
          //  }
        }
		
        function onSucessState(result) {
            var stateData = jQuery.parseJSON(result);
            jQuery("#ddlState").append(jQuery("<option></option>").val("0").html("Select"));
            if (stateData.length > 0) {
                jQuery("#ddlState").append(jQuery("<option></option>").val("-1").html("All"));
            }
            for (i = 0; i < stateData.length; i++) {
                jQuery("#ddlState").append(jQuery("<option></option>").val(stateData[i].ID).html(stateData[i].State));
            }
            jQuery('#ddlState').trigger('chosen:updated');


        }
            function onFailureState() {

            }     
            function bindPanel() {
                //if (jQuery("#ddlBusinessZone").val() == 0) {
                //    toast('Error', 'Please Select BusinessZone');
                //    jQuery("#ddlBusinessZone").focus();
                //    return;
                //}
                //if (jQuery("#ddlState").val() == 0) {
                //    toast('Error', 'Please Select State');
                //    jQuery("#ddlState").focus();
                //    return;
                //}
                jQuery('#<%=lstPanel.ClientID%> option').remove();
                jQuery('#lstPanel').multipleSelect("refresh");

                serverCall('../Invoicing/Services/Panel_Invoice.asmx/bindPanel', { BusinessZoneID: jQuery("#ddlBusinessZone").val(), StateID: jQuery("#ddlState").val(), SearchType: jQuery("#rblSearchType input[type=radio]:checked").val(), PaymentMode: '', TagBusinessLab: '', PanelGroup: jQuery("#rblSearchType input[type=radio]:checked").next('label').text(),IsInvoicePanel:2, BillingCycle: jQuery("#ddlInvoiceBillingCycle").val() }, function (response) {
                    jQuery("#lstPanel").bindMultipleSelect({ data: JSON.parse(response), valueField: 'Panel_ID', textField: 'Company_Name', controlID: jQuery("#lstPanel") });
                });
            }        
    </script>
    <script type="text/javascript">
        function clearControl() {
			//bindBusinessZone();
			//bindState();
            jQuery('#ddlBusinessZone').prop('selectedIndex', 0);                                       
          //  jQuery('#ddlState').empty();        
            jQuery('#<%=lstPanel.ClientID%> option').remove();
            jQuery('#lstPanel').multipleSelect("refresh");
            jQuery('#div_Data').html('');
            jQuery('#div_Data,#btnSave').hide();
            jQuery("#labResultData").hide();         
            jQuery('#ddlState,#ddlBusinessZone').trigger('chosen:updated');                     
        }
        function cancelControl() {
            clearControl();
            jQuery('#div_Data,#btnSave').hide();
            jQuery("#labResultData").hide();
        }
        

        //function chkradio() {
        //    if ($('#chkAll').is(':checked') == true) {
        //        $('#rblSearchType').hide();
        //    }
        //    else {
        //        $('#rblSearchType').show();
        //    }
        //    bindPanel();
        //}

        $('#rblSearchType').change(function () {
            bindPanel();
        });

    </script>   
</asp:Content>