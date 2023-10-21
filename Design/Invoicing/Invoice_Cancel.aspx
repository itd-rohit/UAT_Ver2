<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Invoice_Cancel.aspx.cs" ClientIDMode="Static" Inherits="Design_Invoicing_Invoice_Cancel" MasterPageFile="~/Design/DefaultHome.master" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
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
  <div id="Pbody_box_inventory">
       <Ajax:ScriptManager  ID="ScriptManager1" runat="server" EnablePageMethods="true">
             <Services>
               <Ajax:ServiceReference Path="../Common/Services/CommonServices.asmx" />
               <Ajax:ServiceReference Path="Services/Panel_Invoice.asmx" />
           </Services>
     </Ajax:ScriptManager>
        <div  class="POuter_Box_Inventory" style="text-align:center" >          
                <b>Invoice Cancel</b>                
        </div>
        <div  class="POuter_Box_Inventory">           
             <div class="row">
                 <div class="col-md-3">
                     </div>
                <div class="col-md-3">
                    <label class="pull-left">From Date</label>
                    <b class="pull-right">:</b>
                    </div>
                 <div class="col-md-2">
                <asp:TextBox ID="txtFromDate" runat="server" ></asp:TextBox>             
               <cc1:CalendarExtender runat="server" ID="calFromDate" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" />        

                     </div>
                 <div class="col-md-5">
                     </div>
                   <div class="col-md-2">
                    <label class="pull-left">To Date</label>
                    <b class="pull-right">:</b>
                    </div>
                 <div class="col-md-2">
                     <asp:TextBox ID="txtToDate" runat="server" ></asp:TextBox>
             
             <cc1:CalendarExtender runat="server" ID="calToDate" TargetControlID="txtToDate" Format="dd-MMM-yyyy"/>
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
                     <asp:DropDownList ID="ddlBusinessZone" runat="server" onchange="bindState()"  class="ddlBusinessZone chosen-select">
                        </asp:DropDownList>
                     </div>
                 <div class="col-md-2">
                     </div>
                 <div class="col-md-2">
                    <label class="pull-left">State</label>
                    <b class="pull-right">:</b>
                    </div>
                 <div class="col-md-5">
                     <asp:DropDownList ID="ddlState" runat="server" onchange="bindPanel()" class="ddlState chosen-select">
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
                     <asp:DropDownList ID="ddlPanel" runat="server" class="ddlPanel chosen-select"></asp:DropDownList>
                     </div>
                     </div>

             <div class="row">
                  <div class="col-md-3">
                     </div>
                <div class="col-md-3">
                    <label class="pull-left">Invoice No.</label>
                    <b class="pull-right">:</b>
                    </div>
                 <div class="col-md-5">
                     <asp:TextBox ID="txtInvoice" runat="server" ></asp:TextBox>
                     </div>
                 </div>

             <div class="row">
                  <div class="col-md-3">
                     </div>
                <div class="col-md-3">
                    <label class="pull-left">Cancel Reason</label>
                    <b class="pull-right">:</b>
                    </div>
                 <div class="col-md-5">
                     <asp:TextBox ID="txtReason" runat="server" MaxLength="50" CssClass="requiredField"></asp:TextBox>     
                     </div>

                 </div>
                                    
            </div>
             <div class="POuter_Box_Inventory" style="text-align:center">                        
                <input id="btnSearch" type="button" value="Search"  class="searchbutton" onclick="SearchInvoiceCancel()" />
                       <input id="btnCancel" type="button" value="Invoice Cancel"  class="searchbutton" style="display:none" onclick="$SaveInvoiceCancel()" />
                 </div>
             <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Result
            </div>
                  <div class="row" >
                <div class="col-md-24">
           <div id="div_Invoice" style="max-height:350px; overflow:auto;">
              </div>  
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
                   $(selector).chosen(config[selector]);
               }
               jQuery('#ddlBusinessZone').trigger('chosen:updated');
               bindState();
           });
   </script>
       <script id="tb_Invoice" type="text/html">
            <div class="row" >
                <div class="col-md-24">
   <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdInvoice" 
    style="border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:160px;">Invoice No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:220px;">Client Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">Invoice Date</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px;">Created By</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Invoice Amt.</th>			
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;"> <input  type="checkbox"  class="chlAll" onclick="allChk(this)"   />
			 </th>	       
</tr>

       <#      
              var dataLength=InvoiceData.length;
              var objRow; 
               
              for(var j=0;j<dataLength;j++)
               {                                   
                  objRow = InvoiceData[j];               
        #>
                    <tr id="<#=objRow.InvoiceNo#>"  >
<td class="GridViewLabItemStyle"><#=j+1#></td>
<td id="tdInvoiceNo"  class="GridViewLabItemStyle"><#=objRow.InvoiceNo#></td>
<td id="tdPanelName"  class="GridViewLabItemStyle" ><#=objRow.PanelName#></td>
<td id="tdInvoiceDate"  class="GridViewLabItemStyle"><#=objRow.Date#></td>
<td id="tdInvoiceCreatedBy"  class="GridViewLabItemStyle" ><#=objRow.InvoiceCreatedBy#></td>
<td id="tdInvoiceAmt"  class="GridViewLabItemStyle"  style="text-align:right"><#=objRow.InvoiceAmt#></td>
<td class="GridViewLabItemStyle"><input id="chk" type="checkbox"   class="chkInd"  /></td>
<td id="tdEntryByID"  class="GridViewLabItemStyle" style="display:none"><#=objRow.EntryByID#></td>

                        
</tr>

            <#}#>

     </table> 
                    </div>  
                       </div>     
    </script>
       <script type="text/javascript">
           function SearchInvoiceCancel() {
               if ($.trim($("#ddlPanel").val()) == "0" || $.trim($("#ddlPanel").val())=="") {
                   toast("Error", "Please Select Client Name");
                   $("#ddlPanel").focus();
                   return;
               }

               serverCall('Invoice_Cancel.aspx/SearchInvoiceCancel', { dtFrom: $("#txtFromDate").val(), dtTo: $("#txtToDate").val(), PanelID: $("#ddlPanel").val(), InvoiceNo: $("#txtInvoice").val() }, function (response) {

                   InvoiceData = jQuery.parseJSON(response);
                   if (InvoiceData != '') {
                       var output = jQuery('#tb_Invoice').parseTemplate(InvoiceData);
                       jQuery("#div_Invoice").html(output);
                       jQuery("#btnCancel").show();
                   }
                   else {
                       toast('Info','No Record Found');
                       jQuery("#div_Invoice").html('');
                       jQuery("#btnCancel").hide();
                   }
               });

           }
</script>
<script type="text/javascript">
    function allChk(rowID) {
        if (jQuery(".chlAll").is(':checked')) {
            jQuery(".chkInd").prop('checked', 'checked');
        }
        else {
            jQuery(".chkInd").prop('checked', false);
        }
    }
    function getInvoiceDetail() {
        var dataInvoice = new Array();
        var ObjInvoice = new Object();
        jQuery("#tb_grdInvoice tr").find(':checkbox').filter(':checked').each(function () {
            var id = $(this).closest("tr").attr("id");
            var $rowid = $(this).closest("tr");
            if (id != "Header") {
                ObjInvoice.InvoiceNo = jQuery(this).closest("tr").find("#tdInvoiceNo").text();
                ObjInvoice.InvoiceAmt = jQuery(this).closest("tr").find("#tdInvoiceAmt").text();
                ObjInvoice.InvoiceCreatedBy = jQuery(this).closest("tr").find("#tdEntryByID").text();
                ObjInvoice.InvoiceDate = jQuery(this).closest("tr").find("#tdInvoiceDate").text();
                dataInvoice.push(ObjInvoice);
                ObjInvoice = new Object();
            }
        });
        return dataInvoice;
    }

    function $SaveInvoiceCancel() {
        if ($.trim($("#<%=txtReason.ClientID %>").val()) == "") {
            toast("Error", "Please Enter Cancel Reason");
            $("#<%=txtReason.ClientID %>").focus();
            return;
        }
        var InvoiceDetail = getInvoiceDetail();
        if (InvoiceDetail.length > 0) {
            jQuery("#btnCancel").attr('disabled', true);
            serverCall('Invoice_Cancel.aspx/SaveInvoiceCancel', { InvoiceDetail: InvoiceDetail, CancelReason: $.trim($("#<%=txtReason.ClientID %>").val()) }, function (response) {
                if ((response.split('$')[1]) == "1") {
                    jQuery('select option:nth-child(1)').attr('selected', 'selected')
                    jQuery("#tb_grdInvoice tr").find("#chk").attr("checked", false);
                    toast("Success", "Record Cancel Successfully");
                    jQuery("#div_Invoice").empty();
                }
                else if ((response.split('$')[1]) == "2") {
                    toast("Error", "Please Cancel Receipt for Invoice No.  " + (response.split('$')[0]) + " ");
                }
                else {
                    toast("Error", "Record Not Cancel");
                }
                jQuery("#btnCancel").attr('disabled', false);

            });
        }
        else
            toast("Error", "Please Select Invoice");
    }
</script>
    <script type="text/javascript">
        function bindState() {
            jQuery("#ddlState option").remove();
            jQuery('#ddlState').trigger('chosen:updated');
            jQuery('#ddlPanel option').remove();
            jQuery('#ddlPanel').trigger('chosen:updated');
           // if (jQuery("#ddlBusinessZone").val() != 0)
                CommonServices.bindState(0, jQuery("#ddlBusinessZone").val(), onSucessState, onFailureState);
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
         // /  if (jQuery("#ddlBusinessZone").val() == 0) {
         // /      toast("Error", 'Please Select BusinessZone');
         // /      jQuery("#ddlBusinessZone").focus();
         // /      return;
         // /  }
            if (jQuery("#ddlState").val() == 0) {
                toast("Error", 'Please Select State');
                jQuery("#ddlState").focus();
                return;
            }
            jQuery('#ddlPanel option').remove();
            jQuery('#ddlPanel').trigger('chosen:updated');
            serverCall('Invoice_Cancel.aspx/bindPanel', { BusinessZoneID: jQuery("#ddlBusinessZone").val(), StateID: jQuery("#ddlState").val() }, function (response) {
                jQuery('#ddlPanel').bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'Panel_ID', textField: 'Company_Name', isSearchAble: true });
            });
        }
    </script>             
</div>
</asp:Content>