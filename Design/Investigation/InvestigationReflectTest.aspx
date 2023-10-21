<%@ Page Language="C#" AutoEventWireup="true" CodeFile="InvestigationReflectTest.aspx.cs" Inherits="Design_Investigation_InvestigationReflectTest" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

 <link href="../../App_Style/AppStyle.css" rel="stylesheet" type="text/css" />

   <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
     <%: Scripts.Render("~/bundles/WebFormsJs") %>
      <%: Scripts.Render("~/bundles/JQueryUIJs") %>
     <%: Scripts.Render("~/bundles/Chosen") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <title>Reflect Test</title>
     <style type="text/css">
        .chosen-search { width:400px; }
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
         $.ajax({
             url: "InvestigationReflectTest.aspx/getdata",
             data: '{ TestID: "' + $('#<%=ddltest.ClientID%>').val() + '" }', // parameter map
             type: "POST", // data has to be Posted    	        
             contentType: "application/json; charset=utf-8",
             timeout: 120000,
             dataType: "json",
             success: function (result) {
                 IndentDatas = $.parseJSON(result.d);
                
                     var output = $('#tb_PatientLabSearchs').parseTemplate(IndentDatas);
                     $('#mmmd').html(output);
                    
                 

             },
             error: function (xhr, status) {
                
              
                 window.status = status + "\r\n" + xhr.responseText;
             }
         });
     }

     function saveme() {
         $('#<%=lblMsg.ClientID%>').html('');
         if ($('#<%=ddltest.ClientID%>').val() == "0") {
             $('#<%=lblMsg.ClientID%>').html('Please Select Test');
             return;
         }

         $modelBlockUI();
         $.ajax({
             url: "InvestigationReflectTest.aspx/savedata",
             data: '{ TestID: "' + $('#<%=ddltest.ClientID%>').val() + '" }', // parameter map
             type: "POST", // data has to be Posted    	        
             contentType: "application/json; charset=utf-8",
             timeout: 120000,
             dataType: "json",
             success: function (result) {
                 $('#<%=lblMsg.ClientID%>').html('Record Saved..!');
                 $modelUnBlockUI();
                 getdata();
               
             },
             error: function (xhr, status) {
                 $modelUnBlockUI();
                 alert('Please Contact to ItDose Support Team');
                 window.status = status + "\r\n" + xhr.responseText;
             }
         });


     }

        function deleteme(id) {
            $modelBlockUI();
            $.ajax({
                url: "InvestigationReflectTest.aspx/deleteme",
                data: '{ id: "' + id + '" }', // parameter map
             type: "POST", // data has to be Posted    	        
             contentType: "application/json; charset=utf-8",
             timeout: 120000,
             dataType: "json",
             success: function (result) {
                 $('#<%=lblMsg.ClientID%>').html('Record Delete..!');
                 $modelUnBlockUI();
                 getdata();

             },
             error: function (xhr, status) {
                 $modelUnBlockUI();
                 alert('Please Contact to ItDose Support Team');
                 window.status = status + "\r\n" + xhr.responseText;
             }
            });
        }
</script>
</head>
<body>
    <form id="form1" runat="server">
         <ajax:scriptmanager ID="ScriptManager1" runat="server">
        </ajax:scriptmanager>
       <%-- <Ajax:UpdateProgress id="updateProgress" runat="server">
    <ProgressTemplate>
        <div style="position: fixed; text-align: center; height: 100%; width: 100%; top: 0; right: 0; left: 0; z-index: 9999999; background-color: #000000; opacity: 0.7;">
            <span style="border-width: 0px; position: fixed; padding: 50px; background-color: #FFFFFF; font-size: 36px; left: 40%; top: 40%;">Loading <img src="../Purchase/Image/progress_bar.gif" /></span>
        </div>
    </ProgressTemplate>
</Ajax:UpdateProgress>--%>
      

    <div id="Pbody_box_inventory" style="width:700px;">
        <div class="POuter_Box_Inventory" style="width:700px;">
            <div class="content" style="text-align: center" style="width:700px;">
                <b>Investigation Reflect Test</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" style="color:red;" Font-Bold="true"></asp:Label>
            </div>
            <div class="content" style="text-align: center">
                &nbsp;</div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align:left;width:700px;" >
        <div class="content" style="width:700px;">
       
   <table style="width:600px;">
        <tr>
           <td style="font-weight:bold;color:red;">
               Investigation ::&nbsp;<asp:Label ID="lb" runat="server"></asp:Label>
               </td>
            </tr>
       
        <tr>
           <td style="font-weight:bold;color:red;">
               Ovservation&nbsp;&nbsp; ::&nbsp;<asp:Label ID="lbobs" runat="server"></asp:Label>
           </td>
            </tr>
       
         <tr>
             <td style="font-weight:bold;">Select Test:
                 <asp:DropDownList ID="ddltest" class="ddltest chosen-select" runat="server" Width="400px"></asp:DropDownList>
             </td>
        </tr>
         <tr>
           <td style="text-align:center;">
                 <input type="button" id="save" class="itdosebtnnew" onclick="saveme()" value="Save" />
               </td>
             <tr>
                 <td>
                     <div class="Purchaseheader">
                         Saved Test</div>
                     <div style="height:200px;overflow:scroll;" id="mmmd">
                     </div>
                 </td>
             </tr>
             </tr>
   </table>
        
    
   
        </div>
        
        
        
        </div>



</div>

             
    </form>
</body>


    <script id="tb_PatientLabSearchs" type="text/html"  >
        <table  cellspacing="0" rules="all" border="1" id="tb_grdLabSearchs" 
    style="background-color:White;border-color:#CCCCCC;border-width:1px;border-style:None;width:100%;border-collapse:collapse;">
		<tr>  
			<th style="color:White;background-color:#006699;font-weight:bold;width:50px;" scope="col" >S. No</th>
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
