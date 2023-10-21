<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="BreakPoint.aspx.cs" Inherits="Design_Investigation_BreakPoint" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

  <%: System.Web.Optimization.Scripts.Render("~/bundles/MsAjaxJs") %>


     <script type="text/javascript" language="javascript">


 

         function GetAntibioticList() {
             $modelBlockUI();
             $.ajax({
                 url: "../Lab/Services/LabCulture.asmx/GetAntibioticList",
                 data: '{ groupid:"' + $('#<%=ddlmastertype.ClientID%> option:selected').val() + '"}', // parameter map
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {

                     MasterData = jQuery.parseJSON(result.d);
                     var output = $('#tb_MasterData').parseTemplate(MasterData);
                     $('#divmaster').html(output);

                     $modelUnBlockUI();
                 },
                 error: function (xhr, status) {
                     alert(xhr.responseText);
                     $modelUnBlockUI();
                     window.status = status + "\r\n" + xhr.responseText;
                 }
             });
         }

         function editbreakpoint(str) {
             $modelBlockUI();
             if ($('#' + str).find("#ch").attr('checked')) {
                 $('#' + str).find("#tx").show();
                 $('#' + str).find("#sp").hide();
             }
             else {
                 $('#' + str).find("#tx").hide();
                 $('#' + str).find("#sp").show();
             }
             $modelUnBlockUI();
         }

         function savebreakpoint() {
             var mydata = getcompletedata();
             if (mydata.length == "0") {
                 $('#<%=lblMsg.ClientID%>').html("Please Select data To save..!");
                 return;
             }

             $modelBlockUI();
             $.ajax({
                 url: "../Lab/Services/LabCulture.asmx/SaveBreakPoint",
                 data: JSON.stringify({ mydata: mydata }),
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     if (result.d == '1') {
                         $('#<%=lblMsg.ClientID%>').html('Record Saved SuccessFully');
                         GetAntibioticList();
                     }
                     else {
                         alert(result.d);
                     }

                     $modelUnBlockUI();
                 },
                 error: function (xhr, status) {
                     $modelUnBlockUI();
                     window.status = status + "\r\n" + xhr.responseText;
                 }

             });
         }
      

         function getcompletedata() {

             var tempData = [];

             $('#tb_grdLabSearch tr').each(function () {

                 if ($(this).attr("id") != "header") {
                     if ($(this).find("#ch").is(':checked')) {
                         var Itemmaster = [];
                         Itemmaster[0] = $(this).find('#mapid').html();
                         Itemmaster[1] = $(this).find('#tx').val();
                         tempData.push(Itemmaster);
                     }
                 }
             });
             return tempData;
         }

         function checkall(st) {
             $modelBlockUI();
             $('tbody tr td input[type="checkbox"]').prop('checked', $(st).prop('checked'));
             if ($(st).prop('checked') == true) {
                 $('tbody tr td .tx').show();
                 $('tbody tr td .sp').hide();
             }
             else {
                 $('tbody tr td .tx').hide();
                 $('tbody tr td .sp').show();
             }
             $modelUnBlockUI();
         }
      </script>


     <script id="tb_MasterData" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch" 
    style="width:100%;border-collapse:collapse;text-align:left;">
		<tr id="header">
			<th class="GridViewHeaderStyle" scope="col" style="width:15px;">Sr.No</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">Antibiotic Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">BreakPoint</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;"><input type="checkbox" onclick="checkall(this)" /></th>
</tr>



       <#
       
              var dataLength=MasterData.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {

        objRow = MasterData[j];

         
            #>
                    <tr id="<#=j+1#>" >
<td id="srno" class="GridViewLabItemStyle" style="width:15px;"><#=j+1#></td>
<td id="NAME" class="GridViewLabItemStyle"><#=objRow.name#></td>
<td id="typename" class="GridViewLabItemStyle"><span id="sp" class="sp"><#=objRow.breakpoint#></span> <input type="text" id="tx" class="tx" value="<#=objRow.breakpoint#>"  style="display:none;width:60px;"/><span id="mapid" style="display:none"><#=objRow.mapid#></span></td>
<td id="Td1" class="GridViewLabItemStyle"><input type="checkbox" id="ch" onclick="editbreakpoint('<#=j+1#>')" /></td>
</tr>


            <#}#>

     </table> 
           
    </script>



     <div id="Pbody_box_inventory" style="width:1000px;">
        <div class="POuter_Box_Inventory" style="width:1000px;" >
            <div class="content" style="text-align: center; width:1000px;">
                <b>&nbsp;BreakPoint Master</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
            </div>
            </div>
              <div class="POuter_Box_Inventory" style="width:1000px;" >
                  <div class="Purchaseheader">Group</div>
            <div class="content" style="text-align: center; width:1000px; ">
        <table style="width:100%;">
            <tr>
                <td></td>
                <td style="width: 198px"></td>
                <td style="text-align: right; font-weight: 700;">Organism:&nbsp;</td>
                <td style="text-align: left"><asp:DropDownList ID="ddlmastertype" runat="server" Width="202px" onchange="GetAntibioticList()"></asp:DropDownList></td>
               
                <td></td>
            </tr>
            </table>
            </div>
        </div>


          <div class="POuter_Box_Inventory" style="width:1000px;" >
                
            <div class="content" style="text-align: center; width:1000px; ">
                 <table width="100%">
                   <tr>
                 <td align="center">
                     &nbsp;&nbsp;
                     <input type="button" value="Save BreakPoint" class="ItDoseButton" id="btnmapping" onclick="savebreakpoint()" />
                   
                 </td>
            </tr>
        </table>
             </div>



         </div>


           <div class="POuter_Box_Inventory" style="width:1000px;" >
                  <div class="Purchaseheader">Antibiotic  Detail</div>
            <div class="content" style="text-align: center; width:1000px; ">

                <div id ="divmaster" class="content" style="overflow:scroll;height:360px;width:98%;">

</div>

                </div></div>
         </div>
</asp:Content>

