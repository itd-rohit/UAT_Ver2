<%@ Page  Language="C#" MasterPageFile="~/Design/DefaultHome.master" EnableEventValidation="false" ClientIDMode="Static" AutoEventWireup="true" CodeFile="DesignationMaster.aspx.cs" Inherits="Design_Sales_DesignationMaster" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
     <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
      <script type="text/javascript" src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	  <script type="text/javascript" src="/mdrcnew/Scripts/jquery.tablednd.js"></script>
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
 
        
<Ajax:ScriptManager AsyncPostBackErrorMessage="Error..." ID="ScriptManager1" EnablePageMethods="true" runat="server">  
     </Ajax:ScriptManager> 
    
    
 <div id="Pbody_box_inventory" class="Degignation" style="height: 568px;width:1304px;" >
   <div class="POuter_Box_Inventory"  style="text-align:center;width:1300px;">
    <b>Designation Master</b><br />
      <asp:Label ID="lblerrmsg" runat="server"  CssClass="ItDoseLblError"></asp:Label>&nbsp;

  </div>
   <div class="POuter_Box_Inventory" style="width:1300px;">
    <div class="Purchaseheader">Designation Master</div>                  
      <table id="TBMain"  style="width: 100%; " >
                        
                         <tr>
                            <td style="width: 30%;text-align:right" >
                               Designation :&nbsp;</td>
                            <td style="width: 70%" >
                                <asp:TextBox ID="txtDesignation" runat="server"  Width="250px" MaxLength="50"></asp:TextBox>
                                <input type="hidden" value="0" id="hdnid" />
                              </td> 
                        </tr>    
                                                                    
                         <tr>
                            <td style="width: 30%;text-align:right" >
                                &nbsp;</td>
                            <td style="width: 70%" >
                                <label for="chkIsShowSpecialRate">Show Special Rate</label>
                            <input type="checkbox" id="chkIsShowSpecialRate"   class="Chk"  />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <label for="chkNewTestApprove">New Test Approve</label>
                                 <input type="checkbox" id="chkNewTestApprove"   class="Chk"  />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                  <label for="chkDirectApprove">Direct Approve</label>
                                <input type="checkbox" id="chkDirectApprove"  class="Chk"   />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            </td> 
                        </tr>    
                                                                    
                    </table> 

       <div style="text-align:center;width:996px; padding-top:5px; padding-bottom:5px;">        
           <table style="width:100%;border-collapse:collapse">
               <tr>
                   <td style="width:56%;text-align:right">
                        <button id="btnSave" type="button" class="searchbutton" onclick="SaveTest()" style="width:80px; ">Save</button>
                   </td>
                   <td style="width:44%;text-align:center">
                        <button id="btnAppVerify" type="button" class="btn " onclick="AppVerify()" style="width:120px; margin-right:100px;display:none">Approve/Verify</button>   
                   </td>
               </tr>
           </table>
      
                    
   </div>
   </div>   
   <div class="POuter_Box_Inventory" style="width:1300px;">  
     <div id="div_Designation"  style="max-height:433px; overflow-y:auto; overflow-x:hidden;">       
        </div>       
   </div>     
   <script id="tb_Designation" type="text/html" >      
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdDesignation" style="border-collapse:collapse;width:1260px;"> 
            <thead>
		<tr >
			<th class="GridViewHeaderStyle" scope="col" style="width:30px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:200px;">Designation</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">No. of Employee</th>			
			<th class="GridViewHeaderStyle" scope="col" style="width:30px;">Priority </th>           
            <th class="GridViewHeaderStyle" scope="col" style="width:70px;">Status </th>         
            <th class="GridViewHeaderStyle" scope="col" style="width:200px;"> <button id="btnSaveChanges" type="button" class="searchbutton" onclick="SaveChanges()" >Save Changes</button> &nbsp;&nbsp;<asp:Button ID="btnexport" runat="server" CssClass="searchbutton" Text="Export to excel"  OnClick="btnexport_Click" /> </th>                   
            <th class="GridViewHeaderStyle" scope="col" style="width:70px;">Show Special Rate </th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:70px;">New Test Approve </th>
            <th class="GridViewHeaderStyle" scope="col" style="width:70px;">Direct Approve </th>
        </tr>
                </thead>            
            <tbody class="">
       <#      
              var dataLength=ViewData.length;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {            
        objRow = ViewData[j];
                 #>            
            <tr emp="<#=objRow.EmpCount#>" class="">                          
            <td class="GridViewLabItemStyle" style="text-align:center;" ><#=j+1#></td>               
            <td  class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.Name#></td>
            <td  class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.EmpCount#></td>
            <td  class="GridViewLabItemStyle Sequence" style="text-align:center;"><#=objRow.SequenceNo#></td>           
            <td  class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.CurrentStatus#></td>
            <td  class="GridViewLabItemStyle ID" style="text-align:center; display:none;"><#=objRow.ID#></td>
            <td  class="GridViewLabItemStyle" style="text-align:center;">
                <a href="#" id="btnEdit"  onclick="Edit('<#=objRow.ID#>','<#=objRow.Name#>','<#=objRow.IsShowSpecialRate#>','<#=objRow.IsNewTestApprove#>','<#=objRow.IsDirectApprove#>',this)">                       
                     <img style="width: 15px;" src="../../App_Images/Edit.png" /></a>&nbsp;&nbsp;                                     
                <a href="#" id="btndeactive"  onclick="Delete('<#=objRow.ID#>','0','Deactive')"
                      <#if(objRow.CurrentStatus=="Deactive"){#>
                      style="display:none"
                      <#} #>>
                     <img style="width: 15px;" src="../../App_Images/Delete.gif" /></a>                                   
                 <a href="#" id="btnactive"  onclick="Delete('<#=objRow.ID#>','1','Active')"
                       <#if(objRow.CurrentStatus=="Active"){#>
                      style="display:none"
                      <#} #>>
                     <img style="width: 15px;" src="../../App_Images/Post.gif" /></a>               
                &nbsp;&nbsp; &nbsp;&nbsp; 
                  <a href="#" id="A1"  onclick="ViewEmployee('<#=objRow.ID#>',this)">                      
                     <img style="width: 15px;" src="../../App_Images/view.gif" /></a>                
            </td> 
                <td  class="GridViewLabItemStyle" style="text-align:center;">
                    <input  type="checkbox" id="chkShowSpecialRate" 
                        <#
                        if(objRow.IsShowSpecialRate=="1"){#>
                    checked="checked" 
                    <#}
                         #>
                        />
                    </td> 
                <td  class="GridViewLabItemStyle" style="text-align:center;">
                    <input  type="checkbox" id="chkIsNewTestApprove" 
                        <#
                        if(objRow.IsNewTestApprove=="1"){#>
                    checked="checked" 
                    <#}
                         #>
                        />
                    </td> 
                <td  class="GridViewLabItemStyle" style="text-align:center;">
                    <input  type="checkbox" id="chkIsDirectApprove" 
                        <#
                        if(objRow.IsDirectApprove=="1"){#>
                    checked="checked" 
                    <#}
                         #>
                        />
            </td>                
            </tr>                  
      <#}#>
            </tbody>
        </table>    
    </script> 
      <asp:Button ID="btnhiddenAddItem" runat="server" Style="display:none" />
    <cc1:ModalPopupExtender ID="Employeepop" runat="server"
                            DropShadow="true" TargetControlID="btnhiddenAddItem" CancelControlID="closeEmployee" BackgroundCssClass="filterPupupBackground"
                            PopupControlID="pnlItemDisplay"  OnCancelScript="closeEmployee()"  BehaviorID="Employeepop">
                        </cc1:ModalPopupExtender>  
    <asp:Panel ID="pnlItemDisplay" runat="server" Style="display: none;width:800px; height:485px; " CssClass="pnlVendorItemsFilter"> 
             <div  class="Purchaseheader">
        <table style="width:100%; border-collapse:collapse" border="0">                                                  
                <tr> 
                    <td> Employee Detail :&nbsp;<span id="lblDeginationName"></span></td>                   
                    <td  style="text-align:right">      
                        <img id="closeEmployee" alt="1" src="../../App_Images/Delete.gif"  style="cursor:pointer;" />  
                    </td>                    
                </tr>
            </table>   
      </div>
              <table style="width: 100%;border-collapse:collapse">                
                  <tr>
                      <td>
            <div id="div_Employies" style="text-align:center;  width:99%; max-height:450px;overflow-y:scroll;">               
            </div>                 
                      </td>
                  </tr>                    
                </table>    
       
    </asp:Panel>
    <script id="tb_Employee" type="text/html" >
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tbl_Employee" style="border-collapse:collapse; width:100%;" >
		<tr id="itemheader">
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:70px;">EmployeeID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Employee Code</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Employee Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:70px;">Mobile No</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Email</th>            
</tr>
       <#      
              var EmpDataLength=EmpData.length;          
              var objRow;   
        for(var j=0;j<EmpDataLength;j++)
        {
        objRow = EmpData[j];        
            #>
 <tr>                                      
     <td class="GridViewLabItemStyle"><#=j+1#></td>
     <td id="td3" class="GridViewLabItemStyle"><#=objRow.Employee_ID#></td> 
     <td id="td5" class="GridViewLabItemStyle"><#=objRow.EmpCode#></td>  
     <td id="td4" class="GridViewLabItemStyle"><#=objRow.Title#> <#=objRow.NAME#> </td>
     <td id="td1" class="GridViewLabItemStyle"><#=objRow.Mobile#> </td>
     <td id="td2" class="GridViewLabItemStyle"><#=objRow.Email#> </td>     
</tr>
            <#}#>
     </table>    
    </script>
</div>
    <script type="text/javascript">
        $(function () {
            $(".Chk").checkboxradio();
        });
        var ViewData = "";
        var EmpData = "";
        var Ischange = false;
        jQuery(function () {
            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': { allow_single_deselect: true },
                '.chosen-select-no-single': { disable_search_threshold: 10 },
                '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chosen-select-width': { width: "95%" }
            }
            for (var selector in config) {
                jQuery(selector).chosen(config[selector]);
            }
            BindData();

        });
       
        function BindData() {
            Ischange = false;
            jQuery.ajax({
                url: "DesignationMaster.aspx/GetDesignation",
                data:{}, 
                type: "POST", 
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    ViewData = jQuery.parseJSON(result.d);
                    var output = jQuery('#tb_Designation').parseTemplate(ViewData);
                    jQuery('#div_Designation').html(output);
                    nodrag();
                    jQuery("#tb_grdDesignation").tableDnD({
                        onDragClass: "GridViewDragItemStyle"
                    });
                    jQuery('#tb_grdDesignation tr:even').addClass("GridViewAltItemStyle");
                  
                },
                error: function (xhr, status) {
                }
            });
        }
        function nodrag() {
            jQuery('#tb_grdDesignation > tbody > tr').each(function (i, el) {
                var row=this;
                var val = $(this).attr("emp");
                if (parseInt(val) > 0) {
                    jQuery(row).addClass("nodrag");
                }
                else {
                    jQuery(row).css("background-color", "#47849a");
                }
            });
        }
  </script>     
    <script type="text/javascript">
        var IsUpdate = false;
        function SaveTest() {
            jQuery('#<%=lblerrmsg.ClientID%>').html('');
            if (IsVailid() == "1") {
                return;
            }

            var IsNewTestApprove = jQuery('#chkNewTestApprove').is(':checked') ? 1 : 0;
            var IsDirectApprove = jQuery('#chkDirectApprove').is(':checked') ? 1 : 0;
            var IsShowSpecialRate = jQuery('#chkIsShowSpecialRate').is(':checked') ? 1 : 0;
            jQuery("#btnSave").attr('disabled', 'disabled').text("Saving...");
          
            jQuery.ajax({
                url: "DesignationMaster.aspx/Save",
                data: '{ID:"' + jQuery('#hdnid').val() + '",Name:"' + jQuery('#<%=txtDesignation.ClientID %>').val() + '",IsNewTestApprove:"' + IsNewTestApprove + '",IsDirectApprove:"' + IsDirectApprove + '",IsShowSpecialRate:"' + IsShowSpecialRate + '"}',
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    if (result.d == "1") {
                        jQuery('#<%=lblerrmsg.ClientID%>').html('Record Saved Successfully.');
                        jQuery("#btnSave").removeAttr('disabled').text("Save");
                        clear();
                        BindData();
                    }
                    else if (result.d == "2") {
                        jQuery('#<%=lblerrmsg.ClientID%>').html('Designation already exists !.');
                        $("#btnSave").removeAttr('disabled').text("Save");
                    }
                    else {
                        jQuery('#<%=lblerrmsg.ClientID%>').html('Record Not Saved.');
                        jQuery("#btnSave").removeAttr('disabled').text("Save");
                    }
                },
                error: function (xhr, status) {
                    jQuery('#<%=lblerrmsg.ClientID%>').html('Error has occurred Record Not saved .');
                    jQuery("#btnSave").removeAttr('disabled').text("Save");
                }
            });
        }

        function IsVailid() {
            var con = 0;
            if (jQuery.trim(jQuery('#<%=txtDesignation.ClientID %>').val()) == "") {
                jQuery('#<%=lblerrmsg.ClientID%>').html("Please Enter Designation");
                jQuery('#<%=txtDesignation.ClientID%>').focus();
                con = 1;
                return con;
            }
           
            return con;
        }        
        function clear() {
            jQuery('#<%= txtDesignation.ClientID%>').val('');           
            jQuery('#hdnid').val("0");
            jQuery('#chkIsShowSpecialRate,#chkNewTestApprove,#chkDirectApprove').prop('checked', false).checkboxradio('refresh');

        }
    </script> 
    <script type="text/javascript"> 
        function Edit(Id, Name,IsShowSpecialRate,IsNewTestApprove,IsDirectApprove, e) {
            jQuery('#<%=lblerrmsg.ClientID%>').html('');
            jQuery('#<%=txtDesignation.ClientID %>').val(Name); 
            if (IsShowSpecialRate == "1")               
                jQuery('#chkIsShowSpecialRate').prop('checked', 'checked').checkboxradio('refresh');
            else
                jQuery('#chkIsShowSpecialRate').prop('checked', false).checkboxradio('refresh');

            if (IsNewTestApprove == "1")
                jQuery('#chkNewTestApprove').prop('checked', 'checked').checkboxradio('refresh');
            else
                jQuery('#chkNewTestApprove').prop('checked', false).checkboxradio('refresh');

            if (IsDirectApprove == "1")
                jQuery('#chkDirectApprove').prop('checked', 'checked').checkboxradio('refresh');
            else
                jQuery('#chkDirectApprove').prop('checked', false).checkboxradio('refresh');
            jQuery('#hdnid').val(Id);          
        }
        function Delete(ID, status,massage) {
            var r = confirm("Do you want to " + massage  + "?")
            if (r == true) {
                jQuery.ajax({
                    url: "DesignationMaster.aspx/Delete",
                    data: '{DesignationID:"' + ID + '",Status:"' + status + '"}', // parameter map
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        if (result.d == "2") {
                            jQuery('#<%=lblerrmsg.ClientID%>').html('Designation can not be deactivate because employee(s) are tagged. ');
                        }
                        if (result.d == "1") {
                            jQuery('#<%=lblerrmsg.ClientID%>').html('Record Deleted Successfully.');
                        BindData();
                    }
                },
                   error: function (xhr, status) {
                   }
               });
            }          
        }
        function ViewEmployee(ID, e) {           
            jQuery.ajax({
                    url: "DesignationMaster.aspx/GetEmployee",
                    data: '{DesignationID:"' + ID + '"}', // parameter map
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        EmpData = jQuery.parseJSON(result.d);
                        var output = $('#tb_Employee').parseTemplate(EmpData);
                        jQuery('#div_Employies').html(output);

                        jQuery('#tbl_Employee tr:even').addClass("GridViewAltItemStyle");
                    },
                    error: function (xhr, status) {
                    }
                });
                $find('Employeepop').show();
        }
        function closeEmployee() {
            jQuery('#div_Employies').html('');
            
            $find('Employeepop').hide();
        }
    </script>  
    <script type="text/javascript">  
        function SaveChanges() {
            //if (!Ischange) {
              //  jQuery('#<%=lblerrmsg.ClientID%>').html('nothing has been changed in Designation levels.');
                //return;
            //}
            var dataItem = new Array();
            var obj = new Object();
            jQuery('#tb_grdDesignation > tbody > tr').each(function (i, el) {
                obj.ID = jQuery(this).find(".ID").text();
                obj.Sequence = (i + 1);//$(this).find(".Sequence").text();
                obj.ShowSpecialRate = jQuery(this).closest('tr').find('#chkShowSpecialRate').is(':checked') ? 1 : 0;
                obj.IsNewTestApprove = jQuery(this).closest('tr').find('#chkIsNewTestApprove').is(':checked') ? 1 : 0;
                obj.IsDirectApprove = jQuery(this).closest('tr').find('#chkIsDirectApprove').is(':checked') ? 1 : 0;
                
                dataItem.push(obj);
                obj = new Object();
            });
            jQuery("#btnSaveChanges").attr('disabled', 'disabled').text("Saving...");
            jQuery.ajax({
                type: "POST",
                url: "DesignationMaster.aspx/SaveGridChanges",
                data: "{ItemDetail:'" + JSON.stringify(dataItem) + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) { 
                    if (result.d == "1") {                     
                        jQuery('#<%=lblerrmsg.ClientID%>').html('Record Changes Successfully.');
                        BindData();
                        jQuery("#btnSaveChanges").removeAttr('disabled').text("Save Changes");
                    }
                },
                failure: function (response) {
                    jQuery("#btnSaveChanges").removeAttr('disabled').text("Save Changes");
                    jQuery('#<%=lblerrmsg.ClientID%>').html(response.Message);
                }
            });
        }
    </script>

    
      
<style type="text/css">
      

    .Degignation .GridViewHeaderStyle {
        height: 25px!important;
    }
    .Degignation .GridViewLabItemStyle {
        height: 25px!important;
    }

     .Degignation [type=text], .Degignation select {
        padding: 5px 5px;
        margin: 0px 0;
        display: inline-block;
        border: 1px solid #ccc;
        border-radius: 5px;
        box-sizing: border-box;
    }

     .Degignation input[type="button"] {
        outline: none;
    }


    .Degignation .btn {
        display: inline-block;
        *border-bottom: 0 none #b3b3b3;
        display: inline;
        *zoom: 1;
        padding: 4px 12px;
        margin-bottom: 0;
        font-size: 14px;
        line-height: 20px;
        text-align: center;
        vertical-align: middle;
        cursor: pointer;
        color: #333333;
        text-shadow: 0 1px 1px rgba(255, 255, 255, 0.75);
        background-color: #f5f5f5;
        background-repeat: repeat-x;
        border-color: rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.25);
        *-webkit-border-radius: 4px;
        -moz-border-radius: 4px;
        border-radius: 4px;
        margin-left: .3em;
        -webkit-box-shadow: inset 0 1px 0 rgba(255, 255, 255, .2), 0 1px 2px rgba(0, 0, 0, .05);
        -moz-box-shadow: inset 0 1px 0 rgba(255, 255, 255, .2), 0 1px 2px rgba(0, 0, 0, .05);
        box-shadow: inset 0 1px 0 rgba(255, 255, 255, .2), 0 1px 2px rgba(0, 0, 0, .05);
        background-image: linear-gradient(to bottom, #ffffff, #e6e6e6);
        border-left-color: inherit;
        border-left-width: 0;
        border-right-style: none;
        border-right-color: inherit;
        border-right-width: 0;
        border-top-style: none;
        border-top-color: inherit;
        border-top-width: 0;
    }

        .Degignation .btn:hover, .Degignation .btn:focus, .Degignation .btn:active, .Degignation .btn.active, .Degignation .btn.disabled, .Degignation .btn[disabled] {
            color: #333333;
            background-color: #e6e6e6;
            *background-color: #d9d9d9;
        }

        .Degignation .btn:active, .Degignation .btn.active {
            background-color: #cccccc;
        }

        .Degignation .btn:hover, .Degignation .btn:focus {
            color: #333333;
            text-decoration: none;
            background-position: 0 -15px;
            -webkit-transition: background-position 0.1s linear;
            -moz-transition: background-position 0.1s linear;
            -o-transition: background-position 0.1s linear;
            transition: background-position 0.1s linear;
        }

 
</style>
    <script type="text/javascript">
        function closeAppVerify() {
            $find('mpAppVerify').hide();
        }
        function AppVerify()
        {
            PageMethods.bindAppVerify(onSuccessAppVerify, OnfailureAppVerify);
            $find('mpAppVerify').show();
        }
        function OnfailureAppVerify(result)
        {

        }
    </script>

     <cc1:ModalPopupExtender ID="mpAppVerify" runat="server"
                            DropShadow="true" TargetControlID="btnhiddenAddItem"  BackgroundCssClass="filterPupupBackground"
                            PopupControlID="pnlAppVerify"  OnCancelScript="closeAppVerify()"  BehaviorID="mpAppVerify">
                        </cc1:ModalPopupExtender>  
    <asp:Panel ID="pnlAppVerify" runat="server" Style="display: none;width:980px; height:485px; " CssClass="pnlVendorItemsFilter"> 
             <div  class="Purchaseheader">
        <table style="width:100%; border-collapse:collapse" border="0">                                                  
                <tr> 
                    <td> Verify/Approval Master :&nbsp;<span id="Span1"></span></td>                   
                    <td  style="text-align:right">      
                        <img id="Img1" alt="1" src="../../App_Images/Delete.gif"  style="cursor:pointer;" onclick="closeAppVerify()" />  
                    </td>                    
                </tr>
            </table>   
      </div>
               <div id="divAppVerify" style="overflow:auto; height:300px">                 
 
                  <table border="1" id="mtable" style="width:99%;border-collapse:collapse" class="GridViewStyle">
                <thead>
                
                </thead>
                <tbody>
                    
            </tbody>
        </table>  

              </div>  
        <div  style="text-align: center;" >
              <input type="button" id="Button1" onclick="saveAppVerify()" value="Save"  class="ItDoseButton"/>&nbsp;&nbsp;
             </div>
    </asp:Panel>

    <script type="text/javascript">
        
        function onSuccessAppVerify(result) {
            var tbl_body = ""; var tbl_head = "";
            var tbl_hrow = "";
            var data = jQuery.parseJSON(result);
            var count = 0;
            jQuery.each(data, function () {
                var tbl_row = "";
                jQuery.each(this, function (k, v) {
                    if (k == 'Type' || k == 'ID') {
                        if (k == 'ID') {
                            tbl_row += "<td class='GridViewLabItemStyle' style='display: none;'>" + v + "</td>";
                        }
                        else if (k == 'Type') {
                            tbl_row += "<td class='GridViewLabItemStyle' style='width:180px'>" + v + "</td>";
                        }
                        else {
                            tbl_row += "<td class='GridViewLabItemStyle' style='width:60px;text-align:right'>" + v + "</td>";
                        }
                    }
                    else {
                        if (v == null)
                            v = '#';
                        var SelectedValue = v.split('#');
                       
                        //<input type='text' style='width:70px' id='" + k.substr(k.indexOf('#') + 1) + "' class='testValue' value='" + SelectedValue[0] + "'/>
                        tbl_row += "<td class='GridViewLabItemStyle " + k.substr(k.indexOf('#') + 1) + "'><select class='appVerifyValue' style='width:70px' id='ddl" + k.substr(k.indexOf('#') + 1) + "'>";
                        
                        tbl_row += " <option value='0' title='Select'>Select</option>";
                        tbl_row += " <option value='1' title='Verify'>Verify</option>";
                        tbl_row += " <option value='2' title='Approve'>Approve</option>";
                        tbl_row +=" </select>";
                        
                        $(".appVerifyValue option:selected").val(SelectedValue);
                        tbl_row += "</td> ";
                    }
                    if (k == 'Type') {
                        count = count + 1;
                    }
                    if (count == 1) {
                        if (k == 'Type' || k == 'ID' || k == 'DesignationName') {
                            if (k == 'ID') {
                                tbl_hrow += "<td style='width:150px; display: none;' class='GridViewHeaderStyle'>" + k + "</td>";
                            }
                            else if (k == 'Type') {
                                tbl_hrow += "<td style='width:180px;' class='GridViewHeaderStyle'>" + k + "</td>";
                            }
                            else {
                                tbl_hrow += "<td style='width:60px;' class='GridViewHeaderStyle'>" + k + "</td>";
                            }
                        }
                        else {
                            tbl_hrow += "<td style='width:80px;' class='GridViewHeaderStyle " + k.substr(k.indexOf('#') + 1) + "'>" + k + "</td>";
                        }
                    }
                });

                tbl_body += "<tr>" + tbl_row + "</tr>";
            });
            tbl_head = "<tr>" + tbl_hrow + "</tr>";
            jQuery("#mtable thead").html(tbl_head);
            jQuery("#mtable tbody").html(tbl_body);
        }
    </script>


        <script type="text/javascript">
            function saveAppVerify() {
                var isEmptyValue = 0;
                jQuery("#mtable tbody").find('tr').each(function (key, val) {
                    jQuery(this).find('td').find(".appVerifyValue").each(function () {

                        var testValue = jQuery.trim(jQuery(this).closest('td').find(".appVerifyValue option:selected").val());
                        alert(testValue);
                        if (testValue == "0") {
                          
                            jQuery(this).closest('td').find(".appVerifyValue").focus();
                            isEmptyValue = 1;
                            return;
                        }
                       
                        if (isEmptyValue == 1) {
                            return;
                        }

                    });
                });
                if (isEmptyValue == 1) {
                    return;
                }

                

                var dataItem = new Array();
                var item = new Object();
                jQuery("#mtable tbody").find('tr').each(function (key, val) {
                    var $tds = jQuery(this).find('td');
                    var TypeID = parseInt($tds.eq(0).text());
                    var TypeName = $tds.eq(1).text();
                    jQuery(".appVerifyValue", this).each(function () {

                        var DesignationID = parseInt($(this).attr('id'));
                        var AppVerify = this.value;
                        if (AppVerify == 1) {
                            IsVerify = 1;
                            IsApprove = 0;
                        }
                        else {
                            IsVerify = 1;
                            IsApprove = 1;

                        }
                        if (AppVerify.length != 0 && AppVerify.length != '' && AppVerify != 'null') {

                            item.DesignationID = DesignationID;
                            item.IsVerify = IsVerify;
                            item.IsApprove = IsApprove;
                            item.TypeID = TypeID;
                            item.TypeName = TypeName;
                            dataItem.push(item);
                            item = new Object();
                        }
                    });


                });
                if (dataItem.length > 0) {
                    jQuery.ajax({
                        type: "POST",
                        url: "DesignationMaster.aspx/saveAppVerify",
                        data: "{AppVerifyDetail:'" + JSON.stringify(dataItem) + "'}",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (result) {
                            if (result['d'] == "1") {
                               
                            }
                            else {
                             
                            }
                            
                            dataItem.splice(0, dataItem.length);
                        },
                        failure: function (response) {
                           
                          
                        }
                    });
                }
                else {
                   
                    dataItem.splice(0, dataItem.length);
                   
                }

            }
    </script>


</asp:Content>

