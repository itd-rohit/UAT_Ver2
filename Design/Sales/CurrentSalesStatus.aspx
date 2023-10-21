<%@ Page  Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CurrentSalesStatus.aspx.cs" Inherits="Design_Lab_CurrentSalesStatus" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <div id="Pbody_box_inventory" style="width: 1194px">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
            </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="width: 1190px;">

            <div class="content" style="text-align: center; height: 35px;">
                <b>Current Sales Status </b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />

            </div>
        </div>
         <div class="POuter_Box_Inventory" style="width: 1190px;">
            <table style="width: 100%"  class="0">
                <tr>
                    <td style="text-align: center; height: 20px;">
                         <input type="button" id="btnView" onclick="ViewData()" value="View"  class="searchbutton" />&nbsp;&nbsp;&nbsp;
                        <input type="button" id="btnReport" onclick="GetReport()" value="Get Report" class="searchbutton"/>
                    </td>
                </tr>
            </table>
        </div>
         <div class="POuter_Box_Inventory" style="width: 1190px;">
         <table  style="width: 100%; border-collapse:collapse" id="myTable">
                <tr >
                    <td colspan="4">
                        <div id="CurrentSalesStatus" style="max-height: 500px; overflow-x: auto;">
                        </div>
                        <br />
                       
                    </td>
                </tr>
            </table>

              </div>
    </div>
    <script type="text/javascript">
        function GetReport()
        {
            $.ajax({
                url: "CurrentSalesStatus.aspx/GetReport",
                data: '{SearchType:0}',
                async: false,
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    window.open("../Common/SalesReportExportToExcel.aspx");
                }
            });
        }
    </script>
    <script type="text/javascript">
        function ViewData() {
            PageMethods.GetReport("1",onSucessViewData, onFailureData);
        }
        function onSucessViewData(result) {
            CurrentSalesStatus = jQuery.parseJSON(result);
            if (CurrentSalesStatus != null) {
                var output = $('#scCurrentSalesStatus').parseTemplate(CurrentSalesStatus);
                jQuery('#CurrentSalesStatus').html(output);
                jQuery('#CurrentSalesStatus').show();
            }
            else {
                jQuery('#CurrentSalesStatus').html('');
                jQuery('#CurrentSalesStatus').hide();
            }
        }
        function onFailureData(result) {

        }
    </script>
  <script id="scCurrentSalesStatus" type="text/html">

   <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tbCurrentSalesStatus"
    style="border-collapse:collapse;width:100%;">
         <thead>
		<tr id="Header">
            <th class="GridViewHeaderStyle" scope="col" style="width:40px">S.No.</th>	
		    <th class="GridViewHeaderStyle" scope="col" style="width:360px">Employee Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px">Target Money</th>			
			<th class="GridViewHeaderStyle" scope="col" style="width:120px">Target PerDay</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px">Till Day Target</th>	
			<th class="GridViewHeaderStyle" scope="col" style="width:90px" >Till Date Sale</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px">Difference</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:140px">Month End Landing</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px">Avg Sale PerDay</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px">Avg Sale PerDay Required</th>
			
</tr>
       </thead>
       
       <#                     
                  var dataLength=CurrentSalesStatus.length;
       
        var objRow;
     
        for(var j=0;j<dataLength;j++)
        {
        objRow = CurrentSalesStatus[j];
        #>
                    <tr id="<#=j+1#>">
                    <td class="GridViewLabItemStyle"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" style="text-align:left" ><#=objRow.Name#></td>                    
                    <td class="GridViewLabItemStyle" style="text-align:right" ><#=objRow.TargetMoney#></td>
                    <td class="GridViewLabItemStyle" style="text-align:right"><#=objRow.TargetPerDay#></td>
                    <td class="GridViewLabItemStyle" style="text-align:right"><#=objRow.TillDayTarget#></td>
                    <td class="GridViewLabItemStyle" style="text-align:right"><#=objRow.TillDateSale#></td>
                    <td class="GridViewLabItemStyle" style="text-align:right;font-weight:bold; <#if(objRow.Difference >0){#>color:green<#} else{#>color:Red<#}  #>"><#=objRow.Difference#> </td>                                  
                    <td class="GridViewLabItemStyle" style="text-align:right"><#=objRow.MonthEndLanding#></td>
                    <td class="GridViewLabItemStyle" style="text-align:right"><#=objRow.AvgSalePerDay#></td>
                    <td class="GridViewLabItemStyle" style="text-align:right"><#=objRow.AvgSalePerDayRequired#></td>
                   
                    </tr>
        <#}
        #>       
     </table>
    </script>
</asp:Content>

