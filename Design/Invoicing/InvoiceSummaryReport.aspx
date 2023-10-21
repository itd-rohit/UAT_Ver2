<%@ Page  Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="InvoiceSummaryReport.aspx.cs" Inherits="Design_Invoicing_InvoiceSummaryReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/UserControl/CentreTypeAccounts.ascx" TagPrefix="uc1" TagName="CentreTypeAccounts" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <script type="text/javascript" src="../../Scripts/jquery.table2excel.min.js"></script>
       <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
           
             <div class="row">
                <div class="col-md-24" style="text-align:center">
                 <b>Invoice Summary Report</b>
                    </div>
                     </div>

              <div class="row" id="tblType">
                  <div class="col-md-10"></div>
                <div class="col-md-14" style="text-align:center">
                    <uc1:CentreTypeAccounts runat="server" ID="rblSearchType" ClientIDMode="Static" /> 
                    </div>
                  </div>    

        </div>
        <div id="SearchDiv" class="POuter_Box_Inventory" >

              <div class="row">
               <div class="col-md-3">
                   </div>
                <div class="col-md-3">
                    <label class="pull-left">Invoice From Date </label>
                    <b class="pull-right">:</b>
                    </div>
                 <div class="col-md-2">
                      <asp:TextBox ID="txtFromDate" runat="server" ></asp:TextBox>
                        <cc1:CalendarExtender runat="server" ID="calFromdate" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                       </div>
                  <div class="col-md-5">

                       </div>
                   <div class="col-md-3">
                    <label class="pull-left">Invoice To Date </label>
                    <b class="pull-right">:</b>
                    </div>
                 <div class="col-md-2">
                       <asp:TextBox ID="txtToDate" runat="server"></asp:TextBox>
                        <cc1:CalendarExtender runat="server" ID="calToDate" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                    </div>
                    </div>

             <div class="row">
               <div class="col-md-3">
                   </div>
                <div class="col-md-3">
                    <label class="pull-left">Invoice No. </label>
                    <b class="pull-right">:</b>
                    </div>
                 <div class="col-md-5">
                     <asp:TextBox ID="txtInvoiceNo" runat="server" ></asp:TextBox>
                     </div>
                  </div>

             <div class="row">
               <div class="col-md-3">
                   </div>
                <div class="col-md-3">
                    <label class="pull-left">Dispatch Status </label>
                    <b class="pull-right">:</b>
                    </div>
                 <div class="col-md-5">
                       <asp:RadioButtonList ID="rblDispatchStatus" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static">
                            <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                            <asp:ListItem Text="No" Value="0"></asp:ListItem>
                            <asp:ListItem Text="Both" Value="2" Selected="True"></asp:ListItem>
                        </asp:RadioButtonList>
                      </div>
                 <div class="col-md-2">
                   </div>


                  <div class="col-md-3">
                    <label class="pull-left">Cancel Status </label>
                    <b class="pull-right">:</b>
                    </div>
                 <div class="col-md-5">
                     <asp:RadioButtonList ID="rblCancelStatus" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static">
                            <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                            <asp:ListItem Text="No" Value="0"></asp:ListItem>
                            <asp:ListItem Text="Both" Value="2" Selected="True"></asp:ListItem>
                        </asp:RadioButtonList>
                  </div>

                  </div>
            
             </div>
               
              

            

                 <div class="POuter_Box_Inventory" style="text-align:center">
                        <input id="btnSearch" type="button" value="Search" class="searchbutton" onclick="InvoiceSearch()" />
                        <input id="btnexportReport" type="button" value="Report" class="searchbutton" onclick="exportReport()" />

                       

           
        </div>
        <div class="POuter_Box_Inventory" >
            <div class="Purchaseheader">
                Search Result
            </div>      
             <div class="row">
              <div class="col-md-24">    
           <div id="div_Data" style="max-height:350px; overflow:auto;">
              </div>  
                </div>  
                  </div>  
      
 </div>
        </div> 
    
    <script type="text/javascript">
        function InvoiceSearch() {
            serverCall('InvoiceSummaryReport.aspx/SearchInvoice', {dtFrom: jQuery("#txtFromDate").val(),dtTo: jQuery("#txtToDate").val(),InvoiceNo: jQuery("#txtInvoiceNo").val(),SearchType: jQuery("#rblSearchType input[type=radio]:checked").next().text(),DispatchStatus: jQuery("#rblDispatchStatus  input[type=radio]:checked").val(),CancelStatus: jQuery("#rblCancelStatus  input[type=radio]:checked").val()}, function (response) {
                InvoiceData = jQuery.parseJSON(response);
                if (InvoiceData == null) {
                    toast("Error", "No Record Found");
                    jQuery('#div_Data,#btnexportReport').hide();
                }
                else {
                    var output = jQuery('#tb_Invoice').parseTemplate(InvoiceData);
                    jQuery('#div_Data').html(output);
                    jQuery('#div_Data,#btnexportReport').show();
                    jQuery('#tb_grdInvoice').tableHeadFixer({

                    });
                }
            });
        }
        
    </script>
   <script id="tb_Invoice" type="text/html">
   <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdInvoice" 
    style="border-collapse:collapse;width:100%">
        <thead>
		<tr id="Tr1">		   
			<th class="GridViewHeaderStyle" scope="col" style="width:20px;">S.No.</th>	
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">Code</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Invoice No.</th>           
			<th class="GridViewHeaderStyle" scope="col" style="width:450px;">Client Name</th>			
			<th class="GridViewHeaderStyle" scope="col">Invoice&nbsp;Amt.</th>		
                        <th class="GridViewHeaderStyle" scope="col">Invoice&nbsp;Date</th>	
                        <th class="GridViewHeaderStyle" scope="col">From&nbsp;Date</th>
                        <th class="GridViewHeaderStyle" scope="col">To&nbsp;Date</th>
                        <th class="GridViewHeaderStyle" scope="col">Type</th>
                        <th class="GridViewHeaderStyle" scope="col">IsCancel</th>
                        <th class="GridViewHeaderStyle" scope="col">IsDispatch</th>
		</tr>
            </thead>
       <#           
              var dataLength=InvoiceData.length;
              var objRow;               
             for(var j=0;j<dataLength;j++)
               {                                    
                  objRow = InvoiceData[j];
            #>
<tr id="<#=j+1#>" >
                 
    
  <td class="GridViewLabItemStyle"><#=j+1#></td>            

    <td id="tdPanel_Code"  class="GridViewLabItemStyle" style="width:60px"><#=objRow.Panel_Code#></td>
    <td id="tdInvoiceNo"  class="GridViewLabItemStyle" style="width:120px"><#=objRow.InvoiceNo#></td>
    <td id="PanelName"  class="GridViewLabItemStyle" style="width:350px"><#=objRow.PanelName#>   </td>
    <td id="tdShareAmt"  class="GridViewLabItemStyle" style="width:60px;text-align:right"><#=objRow.ShareAmt#></td>
    <td  class="GridViewLabItemStyle" style="width:90px;text-align:center"><#=objRow.InvoiceDate#></td>
    <td class="GridViewLabItemStyle" style="width:90px;text-align:center" id="tdFromDate"><#=objRow.FromDate#></td>
    <td class="GridViewLabItemStyle" style="width:90px;text-align:center" id="tdToDate"><#=objRow.ToDate#></td>
    <td class="GridViewLabItemStyle" style="width:90px;text-align:center" id="td1"><#=objRow.InvoiceType#></td>
    <td class="GridViewLabItemStyle" style="width:60px;text-align:center" id="td2"><#=objRow.IsCancel#></td>
    <td class="GridViewLabItemStyle" style="width:50px;text-align:center" id="td3"><#=objRow.IsDispatch#></td>
</tr>

            <#}#>

     </table>     
    </script>
    <script type="text/javascript">
        function exportReport() {
            $("#tb_grdInvoice").remove(".noExl").table2excel({
                name: "Invoice Report",
                filename: "InvoiceReport", //do not include extension
                exclude_inputs: false
            });
        }
    </script>
</asp:Content>

