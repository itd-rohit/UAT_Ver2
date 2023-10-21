<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CenterIndentRight.aspx.cs" Inherits="Design_Store_CenterIndentRight" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

     
      
     
     <%: Scripts.Render("~/bundles/JQueryStore") %>

       <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 

    

     
     <div id="Pbody_box_inventory">
         <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
      
        </Ajax:ScriptManager>
          <div class="POuter_Box_Inventory" style="text-align:center">
            
                            <b>Location Indent Right/Mapping</b>  
                        
              </div>

         <div class="POuter_Box_Inventory">
          
                <div class="Purchaseheader">
                      From Location Detail</div>
            					
	     <div class="row">
		  <div class="col-md-3 ">
			   <label class="pull-left">CentreType   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-9 ">
			 <asp:ListBox ID="lstCentreTypefrom" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static" onchange="bindCentrefrom()"></asp:ListBox>
		   </div>
             

             <div class="col-md-3 ">
			   <label class="pull-left">Zone   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-9 ">
			<asp:ListBox ID="lstZonefrom" CssClass="multiselect " SelectionMode="Multiple" runat="server"  ClientIDMode="Static" onchange="bindStatefrom($(this).val())"></asp:ListBox>
		   </div>
             </div>
                  <div class="row">
		  <div class="col-md-3 ">
			   <label class="pull-left">State   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-9 ">
			 <asp:ListBox ID="lstStatefrom" CssClass="multiselect " SelectionMode="Multiple" runat="server"  ClientIDMode="Static" onchange="bindCentrecityfrom()"></asp:ListBox>
		   </div>
             

             <div class="col-md-3 ">
			   <label class="pull-left">City   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-9 ">
			<asp:ListBox ID="lstCentrecityfrom" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static" onchange="bindCentrefrom()"></asp:ListBox>
		   </div>
             </div>
              	 <div class="row">
		  <div class="col-md-3 ">
			   <label class="pull-left">Centre   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-9 ">
			  <asp:ListBox ID="lstCentrefrom" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static" onchange="bindlocationfrom()"></asp:ListBox>
		   </div>
            

             <div class="col-md-3 ">
			   <label class="pull-left">Location   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-9 ">
			<asp:ListBox ID="lstlocationfrom" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static"></asp:ListBox>
		   </div>
             </div>
                  <div class="row">
		  <div class="col-md-3 ">
			   <label class="pull-left">IndentType   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-9 ">
			 <asp:DropDownList ID="ddlIndentType" class="chosen-select" runat="server"   >
    <asp:ListItem Value="1">SI</asp:ListItem>
   <%-- <asp:ListItem Value="2">PI</asp:ListItem>--%>
    <asp:ListItem Value="3">DirectTransfer</asp:ListItem>
   
                </asp:DropDownList> </div>
                            
         </div></div>

          <div class="POuter_Box_Inventory" >
          
                <div class="Purchaseheader"> To Location Details</div>
                 				
	     <div class="row">
		  <div class="col-md-3 ">
			   <label class="pull-left">CentreType   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-9 ">
			 <asp:ListBox ID="lstCentreTypeto" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static" onchange="bindCentreto()"></asp:ListBox>
		   </div>
             

             <div class="col-md-3 ">
			   <label class="pull-left">Zone   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-9 ">
			<asp:ListBox ID="lstZoneto" CssClass="multiselect " SelectionMode="Multiple" runat="server"  ClientIDMode="Static" onchange="bindStateto($(this).val())"></asp:ListBox>
		   </div>
             </div>
                  <div class="row">
		  <div class="col-md-3 ">
			   <label class="pull-left">State   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-9 ">
			 <asp:ListBox ID="lstStateto" CssClass="multiselect " SelectionMode="Multiple" runat="server"  ClientIDMode="Static" onchange="bindCentrecityto()"></asp:ListBox>
		   </div>
             

             <div class="col-md-3 ">
			   <label class="pull-left">City   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-9 ">
			 <asp:ListBox ID="lstCentrecityto" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static" onchange="bindCentreto()"></asp:ListBox>
		   </div>
             </div>
              	 <div class="row">
		  <div class="col-md-3 ">
			   <label class="pull-left">Centre   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-9 ">
			  <asp:ListBox ID="lstCentreto" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static" onchange="bindlocationto()"></asp:ListBox>
		   </div>
             

             <div class="col-md-3 ">
			   <label class="pull-left">Location   </label>
			   <b class="pull-right">:</b>
		   </div>
		   <div class="col-md-9 ">
			 <asp:ListBox ID="lstlocationto" CssClass="multiselect " SelectionMode="Multiple"  runat="server" ClientIDMode="Static"></asp:ListBox>
		   </div>
             </div>
                                       
                                               
                                           
               </div>
              


           <div class="POuter_Box_Inventory" style=" text-align:center;">
               
                   <input type="button" value="Save" class="savebutton" onclick="SaveData();" id="btnsave" />
                   <input type="button" value="Reset" class="resetbutton" onclick="Refresh();" />
                   <input type="button" value="Search" class="searchbutton" onclick="SearchRecords()" />
                   <input type="button" value="Export To Excel" class="searchbutton" onclick="ExportToExcel()" />
                   
               </div>

           <div class="row">
                   <table id="tblitemlist" style="width:100%;border-collapse:collapse;text-align:left;">
                                     <tr id="triteheader">
                                        <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                                       
                                        
                                        <td class="GridViewHeaderStyle">From Location</td>
                                        <td class="GridViewHeaderStyle">To Location</td>
                                        <td class="GridViewHeaderStyle">Indent Type</td>
                                        
                                        <td class="GridViewHeaderStyle"><input type="checkbox" onclick="call()" id="hd" />&nbsp;&nbsp;<input onclick="    DeleteRows()" type="button" value="Delete" style="cursor:pointer;background-color:pink; font-weight: 700;" /></td>
                                     </tr>
                                 </table></div>


         </div>



    <script type="text/javascript">
        $(function () {
            $('[id*=lstZonefrom]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=lstZoneto]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

            $('[id*=lstStatefrom]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=lstStateto]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

            $('[id*=lstCentrefrom]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=lstCentreto]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=lstlocationfrom]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=lstlocationto]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            
            $('[id*=lstCentreTypefrom]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

            $('[id*=lstCentreTypeto]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });


            $('[id*=lstCentrecityfrom]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

            $('[id*=lstCentrecityto]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
           
            bindcentertype();
            bindZone();

        });
    </script>
    <script type="text/javascript">

        function bindcentertype() {
            jQuery('#<%=lstCentreTypefrom.ClientID%> option').remove();
             jQuery('#<%=lstCentreTypeto.ClientID%> option').remove();
             jQuery('#lstCentreTypefrom').multipleSelect("refresh");
             jQuery('#lstCentreTypeto').multipleSelect("refresh");

             serverCall('StoreLocationMaster.aspx/bindcentertype',{},function(response){
                 jQuery('#lstCentreTypefrom').bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'Type1', controlID: $("#lstCentreTypefrom"), isClearControl: '' });
               
             jQuery('#lstCentreTypeto').bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'Type1', controlID: $("#lstCentreTypeto"), isClearControl: '' });
         });   
         
                  
                 
             
         }



         function bindZone() {
             jQuery('#<%=lstZonefrom.ClientID%> option').remove();
            jQuery('#<%=lstZoneto.ClientID%> option').remove();
            jQuery('#lstZonefrom').multipleSelect("refresh");
            jQuery('#lstZoneto').multipleSelect("refresh");
            serverCall('../Common/Services/CommonServices.asmx/bindBusinessZone',{},function(response){
                jQuery('#lstZonefrom').bindMultipleSelect({ data: JSON.parse(response), valueField: 'BusinessZoneID', textField: 'BusinessZoneName', controlID: $("#lstZonefrom"), isClearControl: '' });
                jQuery('#lstZoneto').bindMultipleSelect({ data: JSON.parse(response), valueField: 'BusinessZoneID', textField: 'BusinessZoneName', controlID: $("#lstZoneto"), isClearControl: '' });

                   
                
            });
        }
    </script>
    
  
    <script type="text/javascript">

        function bindStatefrom(BusinessZoneID) {
            jQuery('#<%=lstStatefrom.ClientID%> option').remove();
            jQuery('#lstStatefrom').multipleSelect("refresh");
            if (BusinessZoneID != "") {
                serverCall('StoreLocationMaster.aspx/bindState',{BusinessZoneID:BusinessZoneID.toString()},function(response){
                    jQuery('#lstStatefrom').bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'State', controlID: $("#lstStatefrom"), isClearControl: '' });

                       

                   
                });
            }
            bindCentrecityfrom();
        }



        function bindCentrecityfrom() {
          
            var StateID = jQuery('#lstStatefrom').val().toString();
           
            jQuery('#<%=lstCentrecityfrom.ClientID%> option').remove();
            jQuery('#lstCentrecityfrom').multipleSelect("refresh");
            serverCall('StoreLocationMaster.aspx/bindCentrecity',{stateid:StateID},function(response){
                jQuery('#lstCentrecityfrom').bindMultipleSelect({ data: JSON.parse(response), valueField: 'id', textField: 'city', controlID: $("#lstCentrecityfrom"), isClearControl: '' });

                  
                
               
            });
            bindCentrefrom();
        }


        function bindCentrefrom() {
            var StateID = jQuery('#lstStatefrom').val().toString();
            var TypeId = jQuery('#lstCentreTypefrom').val().toString();
            var ZoneId = jQuery('#lstZonefrom').val().toString();
            var cityId = jQuery('#lstCentrecityfrom').val().toString();
            jQuery('#<%=lstCentrefrom.ClientID%> option').remove();
            jQuery('#lstCentrefrom').multipleSelect("refresh");
            if (TypeId != "") {
                serverCall('StoreLocationMaster.aspx/bindCentre', { TypeId: TypeId, ZoneId: ZoneId, StateID: StateID, cityid: cityId }, function (response) {

                    jQuery('#lstCentrefrom').bindMultipleSelect({ data: JSON.parse(response), valueField: 'CentreID', textField: 'Centre', controlID: $("#lstCentrefrom"), isClearControl: '' });

                });
            }
            bindlocationfrom();
        }

        function bindlocationfrom() {


            var StateID = jQuery('#lstStatefrom').val().toString();
            var TypeId = jQuery('#lstCentreTypefrom').val().toString();
            var ZoneId = jQuery('#lstZonefrom').val().toString();
            var cityId = jQuery('#lstCentrecityfrom').val().toString();


            var centreid = jQuery('#lstCentrefrom').val().toString();
            jQuery('#<%=lstlocationfrom.ClientID%> option').remove();
            jQuery('#lstlocationfrom').multipleSelect("refresh");
            serverCall('CenterIndentRight.aspx/bindlocation',{centreid:centreid,StateID:StateID,TypeId:TypeId,ZoneId:ZoneId,cityId:cityId },function(response){
                jQuery('#lstlocationfrom').bindMultipleSelect({ data: JSON.parse(response), valueField: 'LocationID', textField: 'Location', controlID: $("#lstlocationfrom"), isClearControl: '' });

                   
            });

        }
    </script>
   
       

    <script type="text/javascript">
       
        

        function bindStateto(BusinessZoneID) {
            jQuery('#<%=lstStateto.ClientID%> option').remove();
            jQuery('#lstStatefrom').multipleSelect("refresh");
            if (BusinessZoneID != "") {
                serverCall('StoreLocationMaster.aspx/bindState',{BusinessZoneID:BusinessZoneID.toString()},function(response){
                    jQuery('#lstStateto').bindMultipleSelect({ data: JSON.parse(response), valueField: 'ID', textField: 'State', controlID: $("#lstStateto"), isClearControl: '' });
                  
                });
            }
            bindCentrecityto();
           
        }

        function bindCentrecityto() {
            var StateID = jQuery('#lstStateto').val().toString();

            jQuery('#<%=lstCentrecityto.ClientID%> option').remove();
            jQuery('#lstCentrecityto').multipleSelect("refresh");
            serverCall('StoreLocationMaster.aspx/bindCentrecity',{stateid:StateID},function(response){
                jQuery('#lstCentrecityto').bindMultipleSelect({ data: JSON.parse(response), valueField: 'id', textField: 'city', controlID: $("#lstCentrecityto"), isClearControl: '' });

            });
            bindCentreto();
        }

        function bindCentreto() {
            var StateID = jQuery('#lstStateto').val().toString();
            var TypeId = jQuery('#lstCentreTypeto').val().toString();
            var ZoneId = jQuery('#lstZoneto').val().toString();
            var cityId = jQuery('#lstCentrecityto').val().toString();
            jQuery('#<%=lstCentreto.ClientID%> option').remove();
            jQuery('#lstCentreto').multipleSelect("refresh");
            if (TypeId != "") {
                serverCall('StoreLocationMaster.aspx/bindCentre', { TypeId: TypeId, ZoneId: ZoneId, StateID: StateID, cityid: cityId }, function (response) {
                    jQuery('#lstCentreto').bindMultipleSelect({ data: JSON.parse(response), valueField: 'CentreID', textField: 'Centre', controlID: $("#lstCentreto"), isClearControl: '' });

                });
            }
            bindlocationto();
        }

        function bindlocationto() {
            var StateID = jQuery('#lstStateto').val().toString();
            var TypeId = jQuery('#lstCentreTypeto').val().toString();
            var ZoneId = jQuery('#lstZoneto').val().toString();
            var cityId = jQuery('#lstCentrecityto').val().toString();


            var centreid = jQuery('#lstCentreto').val().toString();
            jQuery('#<%=lstlocationto.ClientID%> option').remove();
            jQuery('#lstlocationto').multipleSelect("refresh");
            serverCall('CenterIndentRight.aspx/bindlocation',{centreid:centreid,StateID:StateID,TypeId:TypeId,ZoneId:ZoneId,cityId:cityId},function(response){
                jQuery('#lstlocationto').bindMultipleSelect({ data: JSON.parse(response), valueField: 'LocationID', textField: 'Location', controlID: $("#lstlocationto"), isClearControl: '' });

            });

        }
    </script>

    <script type="text/javascript">
        function SaveData() {

            if ($('#lstlocationfrom').val().toString() == '') {
                toast("Error","Please Select From Location","");
                $('#lstlocationfrom').focus();
                return;
            }

            if ($('#lstlocationto').val().toString() == '') {
                toast("Error","Please Select To Location","");
                $('#lstlocationto').focus();
                return;
            }

            var type = $('#<%=ddlIndentType.ClientID%> option:selected').text();

            var fromcenterID = $('#<%=lstlocationfrom.ClientID%>').val().toString();

            var tocenterID = $('#<%=lstlocationto.ClientID%>').val().toString();

            serverCall('CenterIndentRight.aspx/SubmitData',{fcenterID:fromcenterID,tcenterID:tocenterID,IndentType:type},function(response){
         
                
                    if (response != "") {
                        if (response == "True") {
                            $('#<%= lstCentrefrom.ClientID %>').multipleSelect("enable");
                            Refresh();
                            SearchRecords();
                            toast("Success","Grouping Saved Successfully ...!!!","");
                            return;
                        }
                        else {
                            toast(response);

                        }
                    }
                    else {
                        toast("Error","Record Not Saved","");
                    }

               
            });
        }
    </script>
    <script type="text/jscript">
        function Refresh() {
            jQuery('#<%=lstZonefrom.ClientID%> option').remove();
            jQuery('#lstZonefrom').multipleSelect("refresh");

            jQuery('#<%=lstStatefrom.ClientID%> option').remove();
            jQuery('#lstStatefrom').multipleSelect("refresh");

            jQuery('#<%=lstCentrefrom.ClientID%> option').remove();
            jQuery('#lstCentrefrom').multipleSelect("refresh");

            jQuery('#<%=lstCentreTypefrom.ClientID%> option').remove();
            jQuery('#lstCentreTypefrom').multipleSelect("refresh");

           
            jQuery('#<%=lstCentrecityfrom.ClientID%> option').remove();
            jQuery('#lstCentrecityfrom').multipleSelect("refresh");
           


            jQuery('#<%=lstZoneto.ClientID%> option').remove();
            jQuery('#lstZoneto').multipleSelect("refresh");

            jQuery('#<%=lstStateto.ClientID%> option').remove();
            jQuery('#lstStateto').multipleSelect("refresh");

            jQuery('#<%=lstCentreto.ClientID%> option').remove();
            jQuery('#lstCentreto').multipleSelect("refresh");

            jQuery('#<%=lstCentreTypeto.ClientID%> option').remove();
            jQuery('#lstCentreTypeto').multipleSelect("refresh");



            jQuery('#<%=lstlocationfrom.ClientID%> option').remove();
            jQuery('#lstlocationfrom').multipleSelect("refresh");


            jQuery('#<%=lstlocationto.ClientID%> option').remove();
            jQuery('#lstlocationto').multipleSelect("refresh");



            $(':checkbox').prop('checked', false);
       
            bindcentertype();
            bindZone();
        }
    </script>

    <script type="text/javascript">
        function DeleteRows() {

            var data = '';
            $('#tblitemlist tr').each(function () {
                var id = $(this).closest("tr").attr("id");
                if (id != "triteheader") {

                    if ($(this).closest("tr").find('.mmchk').prop('checked') == true) {
                        data = data + "," + id;
                    }
                }
            });


            if (data == '') {
                toast("Error","Please Select Record.","");
                return;
            }
            serverCall('CenterIndentRight.aspx/RemoveData',{Id:data.substr(1, data.length - 1)},function(response){
            if (response == "1") {
                        toast("Success","Record Deleted successfully","");
                        SearchRecords();
                        $(':checkbox').prop('checked', false);
                    }
               
            });



        }

        function call() {

            if ($('#hd').prop('checked') == true) {
                $('#tblitemlist tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "triteheader") {

                        $(this).closest("tr").find('.mmchk').prop('checked', true);

                    }
                });
            }
            else {
                $('#tblitemlist tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "triteheader") {

                        $(this).closest("tr").find('.mmchk').prop('checked', false);

                    }
                });
            }
        }

        function SearchRecords() {
            var fromcenterID = $('#<%=lstlocationfrom.ClientID%>').val().toString();
            var tocenterID = $('#<%=lstlocationto.ClientID%>').val().toString();
            $('#tblitemlist tr').slice(1).remove();
            var type = '';
            serverCall('CenterIndentRight.aspx/SearchData',{fcenterID:fromcenterID,tcenterID:tocenterID,IndentType:type},function(response){
          
                    ItemData = jQuery.parseJSON(response);

                    if (ItemData.length == 0) {
                        toast("Error","No Item Found","");
                        

                    }
                    else {
                        for (var i = 0; i <= ItemData.length - 1; i++) {
                            var $mydata = [];
                            $mydata.push("<tr style='background-color:palegreen;' id='"); $mydata.push( ItemData[i].ID ); $mydata.push(  "'>");


                            $mydata.push( "<td class='GridViewLabItemStyle'>"); $mydata.push(parseInt(i + 1) ); $mydata.push("</td>");
                            $mydata.push('<td class="GridViewLabItemStyle">'); $mydata.push(ItemData[i].FromCenter ); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle">'); $mydata.push(ItemData[i].ToCenter ); $mydata.push('</td>');
                            $mydata.push('<td class="GridViewLabItemStyle">'); $mydata.push(ItemData[i].IndentType); $mydata.push('</td>');
                           
                            $mydata.push('<td class="GridViewLabItemStyle" align="left"><input type="checkbox" class="mmchk" style="align:centre;margin-left:25px" id="'); $mydata.push(ItemData[i].ID); $mydata.push('"/></td>');





                            $mydata.push(  "</tr>");
                            $mydata=  $mydata.join("");
                            $('#tblitemlist').append($mydata);

                        }
                        

                    }

               
            });
        }

        function ExportToExcel() {
            var fromCentre = $('#<%=lstlocationfrom.ClientID%>').val();
            serverCall('CenterIndentRight.aspx/ExportToExcel',{fromCentre:fromCentre},function(response){
          
                    if (response == "true") {
                        window.open('../common/ExportToExcel.aspx');
                    }
                    else {
                        toast("Error","No Record Found..!","");
                    }
                
            });
        }



       
    </script>




    <script type="text/javascript">

        function Selectcentre() {

            if ($('#ContentPlaceHolder1_ddlIndentType option:selected').text() == 'PI') {
                $('#<%= lstCentreto.ClientID %>').multipleSelect().find(":checkbox[value=51]").attr("checked", "checked");
                $('#<%= lstCentreto.ClientID %> option[value=51]').attr("selected", 1);
                $('#<%= lstCentreto.ClientID %>').multipleSelect("refresh");

                $('#<%= lstCentreto.ClientID %>').multipleSelect("disable");

            }
            else {
               
                $('#<%= lstCentreto.ClientID %>').multipleSelect("enable");

            }
        }


    </script>
</asp:Content>

