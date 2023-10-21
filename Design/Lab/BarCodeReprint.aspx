<%@ Page  Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="BarCodeReprint.aspx.cs" Inherits="Design_Lab_BarCodeReprint" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
          <%: System.Web.Optimization.Scripts.Render("~/bundles/MsAjaxJs") %>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>BarCode Reprint</b><br />
             <asp:Label ID="lblLedgertransactionNo" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" style="display:none"></asp:Label>           
        </div>
          <div class="POuter_Box_Inventory">         
               <div class="row">
                        <div id="BarCodeOutput" style="max-height: 500px; overflow-x: auto;">
                        </div>                                                                
             </div>    
              </div>
        </div>

    <script id="tb_BarCodeSearch" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdSearch"
    style="width:1000px;border-collapse:collapse;">
        
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.               
			</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">BarCode No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:240px;">Patient Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:240px;">Test Name</th>  
            <th class="GridViewHeaderStyle" scope="col" style="width:240px;">Department</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Reprint</th>                      
		</tr>
           
        <#
        var dataLength=BarCodeData.length;
        var objRow;
        for(var j=0;j<dataLength;j++)
        {
        objRow = BarCodeData[j];
        #>
                    <tr id="<#=j+1#>">
                    <td class="GridViewLabItemStyle"><#=j+1#> </td>                                                           
                    <td class="GridViewLabItemStyle" id="tdBarcodeNo" style="width:120px;"><#=objRow.BarcodeNo#></td>
                    <td class="GridViewLabItemStyle" id="tdPName" style="width:240px;"><#=objRow.PName#></td>
                    <td class="GridViewLabItemStyle" id="tdItemName" style="width:240px;"><#=objRow.ItemName#></td>
                    <td class="GridViewLabItemStyle" id="tdDepartment" style="width:240px;"><#=objRow.Department#></td>
                        <td class="GridViewLabItemStyle" id="tdRePrint" style="width:60px;text-align:center">
                            <#
                            if(BarCodeData[j].IsSampleCollected=="1")
                            {#>
                             <img src="../../App_Images/print.gif" style="cursor:pointer" onclick="getBarcodeDetail('<#=objRow.Test_Id#>','');" />

                            <#}
                            #>
                           
                        </td>
                    </tr>
        <#}
        #>        
     </table>
    </script>
     <script type="text/javascript">
         var BarCodeData = '';
         $(function () {
             searchBarCode();
         });
         function searchBarCode() {
          serverCall('BarCodeReprint.aspx/bindBarCodeReprint', { LedgertransactionNo: $("#lblLedgertransactionNo").text() }, function (response) {
              var $responseData = JSON.parse(response);
              if ($responseData != null && $responseData != "") {
                  BarCodeData = $responseData;
                  var output = $('#tb_BarCodeSearch').parseTemplate($responseData);
                  $('#BarCodeOutput').html(output);
                  $('#BarCodeOutput').show();
              }
              else {
                  $('#BarCodeOutput').html('');
                  $('#BarCodeOutput').hide();
                  toast("Info", "Record Not Found", "");
              }
          });
         }
         function getBarcodeDetail(_barcode, _labno) {
             try {
                 var barcodedata = new Array();
                 var objbarcodedata = new Object();
                 objbarcodedata.LedgerTransactionNo = '';
                 objbarcodedata.BarcodeNo = '';
                 objbarcodedata.Test_ID = _barcode;
                 barcodedata.push(objbarcodedata);
                 serverCall('Services/LabBooking.asmx/getBarcode', { data: barcodedata }, function (response) {
                     window.location = 'barcode:///?cmd=' + response + '&Source=barcode_source';
                 });
             }
             catch (e) {
             }
         }
         </script>
    <script type="text/javascript">
        function printBarCode() {

        }
    </script>
</asp:Content>

