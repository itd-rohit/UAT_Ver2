<%@ Page Language="C#"  AutoEventWireup="true" CodeFile="ChangePanel.aspx.cs" Inherits="Design_Lab_ChangePanel" Title="Untitled Page" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title></title>
   
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox.pack.js"></script>
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
    <link href="../../../App_Style/multiple-select.css" rel="stylesheet" /> 
    	<script src="../../Scripts/jquery-3.1.1.min.js"></script>
<script src="../../Scripts/Common.js"></script>
<script src="../../Scripts/toastr.min.js"></script>	

     <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
     
    </head><body>
    	
  <form id="form1" runat="server">


    <style type="text/css">
        .chosen-search { width:230px; }
    </style>
   <script type="text/javascript">

     $(document).ready(function () {
            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': { allow_single_deselect: true },
                '.chosen-select-no-single': { disable_search_threshold: 10 },
                '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chosen-select-width': { width: "60%" }
            }
           
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
            if ("<%=Request.QueryString["labno"] %>".length > 0) {
                serverCall('../Common/Services/CommonServices.asmx/decryptData', { ID: "<%=Request.QueryString["labno"] %>" }, function (response) {
                    $("#<%=txtRecipt.ClientID %>").val(response);
             });
         }
        });
  </script>
  <script type="text/javascript">
  
      $(document).ready(function () {
          $("#btnsave").attr('disabled', true);
          $("#BtnReceiptSearch").click(SearchPanel);

      });

      function validation() {
          if ($.trim($('#<%=ddlcentre.ClientID%> :selected').val()) == "") {                           
              toast("Error", "Please select change centre ..!", "");
              return false;
          }
          if ($.trim($('#<%=ddlPanel.ClientID%> :selected').val()) == "") {              
              toast("Error", "Please select change Panel..!", "");
              return false;
          }

          return true;
      }
      function GetSearchData() {
          var dataObj = new Object();
          dataObj.LabNo = $("#<%=txtRecipt.ClientID %>").val();
          dataObj.PanelID = $("#<%=ddlPanel.ClientID %>").val();
          dataObj.FromDate = $("#<%=txtFromDate.ClientID %>").val();
          dataObj.ToDate = $("#<%=txtToDate.ClientID %>").val();
          dataObj.OldPanelID = $("#<%=ddlPanelsearch.ClientID %>").val();
          return dataObj;
      }

  var PanelData="";  
  function SearchPanel() {
      if (validation() == false)
          return;
     
      var searchdata = GetSearchData();
      $("#btnsave").attr('disabled', false);
      $('#tb_grdLabSearch tr').slice(1).remove();

      serverCall('ChangePanel.aspx/SearchPanel', { searchdata: searchdata }, function (response) {
         
          PanelData = JSON.parse(response);
          if (PanelData.status == false) {
              toast("Error",PanelData.ErrorMsg);
          }
          else if (PanelData.length != 0) {
              var output = $('#tb_InvestigationItems').parseTemplate(PanelData);
              $('#div_InvestigationItems').html(output);

          }
          else {
              toast("Error", "Record Not Found..!", "");
          }

          $modelUnBlockUI(function () { });
      });      

  }

      function getdata() {
          var tempData = [];
          $('#tb_grdLabSearch tr').each(function () {
              if ($(this).attr('id') != "header" && $(this).find("#chk").is(':checked')) {
                  var item = new Object();
                  item.LabNo = $(this).find('#td_LedgerTransactionNo').text();
                  item.OldPanelID = $(this).find('#td_OldPanelID').text();
                  item.NewPanelID = $(this).find('#td_NewPanelID').text();
                  tempData.push(item);
              }
          });
          return tempData;
      }

      function SaveNewPanelRates() {
          if (validation() == false)
              return;
          var Data = getdata();
          if (Data.length == 0) {
              toast("Error", "Please select patient to change panel...!", "");
              return;
          }                 
          
          if (confirm("Do You Want To change Panel ") == false) {
              $("#btnsave").attr('disabled', false);
              return;
          }
          $("#btnsave").attr('disabled', true);
          serverCall('ChangePanel.aspx/SaveNewPanelRates', { getData: Data }, function (response) {
              var $responseData = JSON.parse(response);
              if ($responseData.status) {                
                  toast("Success", "Record Saved..!Panel Change Successfully.", "");
                  SearchPanel();
                }
                else {
                    toast("Error", $responseData.ErrorMsg, "");
                    $("#btnsave").attr('disabled', false);
                }
                $modelUnBlockUI(function () { });
            });         
      }
    
 
      function ClearForm() {
          $(':text, textarea').val('');
          $('select option:nth-child(1)').attr('selected', 'selected')
          $("span").text('');
          $("#tb_grdLabSearch tr").remove();

      }

      function call() {
          $("#tb_grdLabSearch tr").each(function () {
              var id = $(this).closest('tr').attr('id');
              if (id != "header") {
                  if ($('#chkall').prop('checked') == true) {
                      $(this).closest('tr').find("#chk").prop('checked', true);
                  }
                  else {
                      $(this).closest('tr').find("#chk").prop('checked', false);
                  }
              }

          });
      }

    </script>
    

            <Ajax:ScriptManager AsyncPostBackErrorMessage="Error..." ID="ScriptManager1" EnablePageMethods="true" runat="server">

                <Scripts>
  <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
     <asp:ScriptReference Path="~/Scripts/jquery.multiple.select.js" />
     <asp:ScriptReference Path="~/Scripts/chosen.jquery.js" />
     <asp:ScriptReference Path="~/Scripts/Common.js" />
    <asp:ScriptReference Path="~/Scripts/toastr.min.js" />
    <asp:ScriptReference Path="~/Scripts/PostReportScript.js" />
</Scripts>

</Ajax:ScriptManager>
<div class="POuter_Box_Inventory">  
<div class="row" style="text-align:center;"> 
    <div class="col-md-24">

        <asp:Label ID="llheader" runat="server" Text="Single/Bulk Panel Change" Font-Size="16px" Font-Bold="true" CssClass="PatientLabel"></asp:Label>
<asp:Label id="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
    </div>  
</div> 
</div>
<div class="POuter_Box_Inventory" >
        <div class="Purchaseheader" >
            Search Option &nbsp;</div>

    <div class="row">
         <div class="col-md-3"></div>
         <div class="col-md-3">  <span>Visit No :</span>  
             </div>
        <div class="col-md-6">
          
             <asp:TextBox id="txtRecipt" tabIndex="1" runat="server" class="requiredField" data-title="Enter Visit No" Width="250px" AutoCompleteType="Disabled" ></asp:TextBox>
        </div>
        <div class="col-md-3">Search Client :</div>
        <div class="col-md-6">
            <asp:DropDownList ID="ddlPanelsearch" class="ddlPanelsearch chosen-select chosen-container"  runat="server" Width="250px">
                                </asp:DropDownList>
            </div>
         <div class="col-md-3"></div>
        </div>
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-3">From Date :</div>
        <div class="col-md-6">
             <asp:TextBox ID="txtFromDate" runat="server" Width="120px" ></asp:TextBox>
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
        </div>
        <div class="col-md-3">To Date :</div>
        <div class="col-md-6">   <asp:TextBox ID="txtToDate" runat="server" Width="120px" ></asp:TextBox>
                 <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender></div>
        <div class="col-md-6"></div>
        
    </div>
         <div class="row">
          <div class="col-md-3"></div>
         <div class="col-md-3"><span>Change Centre:</span></div>
        <div class="col-md-6">
            
             <asp:DropDownList ID="ddlcentre"   CssClass="ddlcentre chosen-select"   runat="server" Width="250px" > </asp:DropDownList>
        </div>
<div class="col-md-3"><span>Change Client:</span></div>
        <div class="col-md-6">
            
              <asp:DropDownList ID="ddlPanel" CssClass="ddlPanel chosen-select"  runat="server" Width="250px" onchange="SearchPanel();"> </asp:DropDownList>
             
        </div>
              <div class="col-md-3"></div>
    </div>
    <div class="row" style="text-align:center">
        <div class="col-md-24">
           
             <input id="BtnReceiptSearch" type="button" value="Search"  class="ItDoseButton" style="width:90px;" />

       
        </div>

    </div>
            </div>
                          
           

<div class="POuter_Box_Inventory" >
            <div class="Purchaseheader">
                Investigation
            </div>
            <div class="row">
                <div class="col-md-24">
                           <div id="div_InvestigationItems" style="max-height:330px; overflow:scroll; text-align:left;">   

                           </div>
                    </div>
            </div>


    <div class="row" style="text-align:center">
                <div class="col-md-24">
<input id="btnsave" type="button" value="save" style="width: 100px ; "  onclick="SaveNewPanelRates()" />
                     </div>
                    </div>





</div>
    



 <script id="tb_InvestigationItems" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" width="100%" border="1" id="tb_grdLabSearch" 
    style="border-collapse:collapse;">
		<tr id="header">
			<th class="GridViewHeaderStyle" scope="col" style="width:40px; ">S.No</th>
            <th class="GridViewHeaderStyle" scope="col" >Visit No</th>
            <th class="GridViewHeaderStyle" scope="col" >PatientName</th>
             <th class="GridViewHeaderStyle" scope="col" >Age</th>
            <th class="GridViewHeaderStyle" scope="col" >Gender</th>
			<th class="GridViewHeaderStyle" scope="col" >Investigation</th>
			<th class="GridViewHeaderStyle" scope="col" >Old Panel</th>
			<th class="GridViewHeaderStyle" scope="col" >New Panel</th>
			<th class="GridViewHeaderStyle" scope="col"  >Old Amount</th>
			<th class="GridViewHeaderStyle" scope="col" > New Amount</th>
			<th class="GridViewHeaderStyle" scope="col" >Disc</th>
			<th class="GridViewHeaderStyle" scope="col" style="display:none">Diff.in Rates</th>
            <th class="GridViewHeaderStyle" scope="col" ><input type="checkbox" id="chkall" checked="checked" disabled="disabled" onclick="call()" /></th>
			
	       

</tr>

       <#
       
              var dataLength=PanelData.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;   
              var diffRates;
              var TotalDiff=0;
        for(var j=0;j<dataLength;j++)
        {

        objRow = PanelData[j];
        
         diffRates=Number(objRow.Rate) -Number(objRow.NewRate);
         TotalDiff+=diffRates;
            #>
                    <tr id="<#=j+1#>" >
<td  class="GridViewLabItemStyle"><#=j+1#></td>
                        <td  class="GridViewLabItemStyle" id="td_LedgerTransactionNo"><#=objRow.LedgerTransactionNo#></td>
                            <td  class="GridViewLabItemStyle"><#=objRow.PName#></td>
                                <td  class="GridViewLabItemStyle"><#=objRow.Age#></td>
                                    <td  class="GridViewLabItemStyle"><#=objRow.Gender#></td>
<td  class="GridViewLabItemStyle"><#=objRow.ItemName#>
 <input type="text" id="txtItemNames" style="display:none" value="<#=objRow.ItemName#>" />
</td>
                        <td  class="GridViewLabItemStyle" ><#=objRow.OldPanel#></td>
                        <td  class="GridViewLabItemStyle" ><#=objRow.NewPanel#></td>
<td  class="GridViewLabItemStyle" style=" text-align:center;"><#=objRow.Rate#></td>
<td  id ="NewPanelRate" class="GridViewLabItemStyle" ><#=objRow.NewRate#> 
   <input type="text" id="txtNewPanelRate" style="display:none" value="<#=objRow.NewRate#>" />
</td>
<td  class="GridViewLabItemStyle" ><#=objRow.DiscountAmt#></td>
<td  class="GridViewLabItemStyle" style=" text-align:center;display:none"><#=diffRates#></td>
                        <td  class="GridViewLabItemStyle" style=" text-align:center;display:none" id="td_OldPanelID"><#=objRow.OldPanelID#></td>
                         <td  class="GridViewLabItemStyle" style=" text-align:center;display:none" id="td_NewPanelID"><#=objRow.NewPanelID#></td>
                        <td  class="GridViewLabItemStyle" style=" text-align:center;"><input type="checkbox" id="chk" checked="checked" disabled="disabled" /></td>

</tr>

            <#}#>
<%--<tr><td colspan="8" style=" text-align:center; color:Red  ; font-weight:bold;" ><span CssClass="ItDoseLblError">Total Diffrence Amount is of Rs.<#=TotalDiff#></span><td></tr>--%>

     </table>    
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#<%=ddlcentre.ClientID%>').change(function () {
                var ddlPanel = $("#<%=ddlPanel.ClientID %>");
                $('#ddlPanel').empty();
                if ($.trim($(this).val()) != "") {

                    serverCall('ChangePanel.aspx/BindPanel', { centreID: $(this).val() }, function (response) {
                        ddlPanel.bindDropDown({ data: JSON.parse(response), valueField: 'panel_id', textField: 'company_name', isSearchAble: true });
                    });                   
                }
            });

        });
    </script>
</form></body></html>

