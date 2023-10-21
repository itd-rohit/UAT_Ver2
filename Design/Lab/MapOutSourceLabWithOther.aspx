<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MapOutSourceLabWithOther.aspx.cs" Inherits="Design_OPD_MapOutSourceLabWithOther" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

 <link href="../../App_Style/AppStyle.css" rel="stylesheet" type="text/css" />
<link href="../../App_Style/grid24.css" rel="stylesheet" type="text/css" />
   <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
     <%: Scripts.Render("~/bundles/WebFormsJs") %>
      <%: Scripts.Render("~/bundles/JQueryUIJs") %>
     <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <title>Reflect Test</title>
     <style type="text/css">
         .chosen-search {
             width: 400px;
         }
     </style>
    <script type="text/javascript">
        $(document).ready(function () {
            getdata();
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
        });
        function getdata() {
            try {
                serverCall('MapOutSourceLabWithOther.aspx/getdata', { TestID: $('#<%=ddltest.ClientID%>').val() }, function (response) {
                    IndentDatas = jQuery.parseJSON(response);

                    var output = $('#tb_PatientLabSearchs').parseTemplate(IndentDatas);
                    $('#mmmd').html(output);
                });
            }
            catch (e) {
            }
        }
        function saveme() {
           
            if ($('#<%=ddltest.ClientID%>').val() == "0") {
                toast("Error", 'Please Select Test');
                return;
            }
            try {
                serverCall('MapOutSourceLabWithOther.aspx/savedata', { TestID: $('#<%=ddltest.ClientID%>').val() }, function (response) {
                    if (response == "1") {
                        toast("Success", 'Record Saved..!');
                    }
                    getdata();
                });
            }
            catch (e) {
                toast("Error", "Please Contact to ItDose Support Team", "");
                window.status = status + "\r\n" + xhr.responseText;
            }
        }
        function deleteme(id) {
            try {
                serverCall('MapOutSourceLabWithOther.aspx/deleteme', { id: id }, function (response) {
                    if (response == "1") {
                        toast("Success", 'Record Delete');
                    }
                    getdata();
                });
            }
            catch (e) {
                toast("Error", "Please Contact to ItDose Support Team", "");
                window.status = status + "\r\n" + xhr.responseText;
            }
        }
</script>
</head>
<body>
    <form id="form1" runat="server">
         <ajax:scriptmanager ID="ScriptManager1" runat="server">
        </ajax:scriptmanager>
       
      

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align:center">
            <div class="row" >
                 <div class="col-md-24">
                <b>OutSource Test With Other Dependent Test</b></div>           
            </div>
       
        </div>
        <div class="POuter_Box_Inventory"  >
      
       <div class="row">
           <div class="col-md-6">   <label class="pull-left">Booking Centre </label>
			  <b class="pull-right">:</b></div>
           <div class="col-md-18"><asp:Label ID="lb" runat="server"></asp:Label></div>

           
       </div>
            <div class="row">
           <div class="col-md-6">   <label class="pull-left">OutSource Centre</label>
			  <b class="pull-right">:</b></div>
                <div class="col-md-18">
                <asp:Label ID="lb1" runat="server"></asp:Label>
                    </div>

            </div>
     
            <div class="row">
           <div class="col-md-6">   <label class="pull-left"> Investigation</label>
			  <b class="pull-right">:</b></div>
                 <div class="col-md-18">
                     <asp:Label ID="lb2" runat="server"></asp:Label></div>
       </div>
            <div class="row">
          <div class="col-md-6">   <label class="pull-left">Select Test</label>
			  <b class="pull-right">:</b></div>
                <div class="col-md-18">
                 <asp:DropDownList ID="ddltest" class="ddltest chosen-select" runat="server"></asp:DropDownList></div>
       </div>
            </div>
             <div class="POuter_Box_Inventory"  style="text-align:center">
           <input type="button" id="save" class="itdosebtnnew" onclick="saveme()" value="Save" /></div>
                 <div class="POuter_Box_Inventory"  >
  <div class="row">
      <div class="col-md-24">
           <div class="Purchaseheader">
                         Saved Test</div>
                     <div style="height:200px;overflow:scroll;" id="mmmd">
                     </div>
      </div> 
  </div>              
                              
        </div>
</div>             
    </form>
</body>


    <script id="tb_PatientLabSearchs" type="text/html"  >
        <table  cellspacing="0" rules="all" border="1" id="tb_grdLabSearchs" 
    style="background-color:White;border-color:#CCCCCC;border-width:1px;border-style:None;width:100%;border-collapse:collapse;">
		<tr>  
			<th style="color:White;background-color:#006699;font-weight:bold;width:50px;" scope="col" >S.No.</th>
			<th style="color:White;background-color:#006699;font-weight:bold;" >Test Name</th>
                        <th style="color:White;background-color:#006699;font-weight:bold;width:50px;">Delete</th>
            
</tr>

<#       
 
 var dataLength=IndentDatas.length;
 
 var objRow; 
         
        for(var j=0;j<dataLength;j++)
        {

        objRow = IndentDatas[j]; 
        
            #>
<tr id="tr_<#=j+1#>" style="color:#000066;"> 
<td ><#=j+1#></td> 
<td ><#=objRow.typename#></td>
<td ><img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleteme('<#=objRow.id#>')" /></td>
    </tr>
 <#}#>
</table>    
    </script>
</html>
