<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" EnableEventValidation="false" AutoEventWireup="true" CodeFile="DesignationEmployeeMaster.aspx.cs" Inherits="Design_Sales_DesignationEmployeeMaster" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
      <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
<link href="../../App_Style/multiple-select.css" rel="stylesheet" />
    
<Ajax:ScriptManager  ID="ScriptManager1" EnablePageMethods="true" runat="server">
  
     </Ajax:ScriptManager> 
    
 <div id="body_box_inventory" class="Degignation" style="height: 568px;width:1304px;" >
   <div class="Outer_Box_Inventory"  style="text-align:center;width:1300px;">
    <b>Designation Add/View Employee Master</b>   
  </div>
  
   <div class="Outer_Box_Inventory" style="width:1300px;"> 
   <asp:HiddenField ID="hdnDesignationId" runat="server" />
       <div style="text-align:right;">
       <asp:Button ID="btnexport" runat="server" CssClass="btn" Text="Export to excel" style="width:120px;" OnClick="btnexport_Click" />
           </div> 
     <div id="div_InvestigationItems"  style="max-height:544px; overflow-y:auto; overflow-x:hidden;">
        
        </div>
       
   </div>     
   <script id="tb_InvestigationItems" type="text/html"> 
      
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch" style="border-collapse:collapse;width:996px;"> 
            <thead>
		<tr >
			<th class="GridViewHeaderStyle" scope="col" style="width:30px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:240px;">Designation</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">No. of Employee</th>			
			<th class="GridViewHeaderStyle" scope="col" style="width:20px;">Priority </th>
            <th class="GridViewHeaderStyle" scope="col" style="width:70px;">Status </th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;"> View </th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;"> Add </th>
            
       
        </tr>
                </thead>

       <#
       
              var dataLength=ViewData.length;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {            

        objRow = ViewData[j];
                 #>
            
            <tr>  
                
               
            <td class="GridViewLabItemStyle" style="text-align:center;" ><#=j+1#></td>
                
            <td  class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.Name#></td>
                <td  class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.EmpCount#></td>
                <td  class="GridViewLabItemStyle Sequence" style="text-align:center;"><#=objRow.SequenceNo#></td>
                <td  class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.CurrentStatus#></td>
                <td  class="GridViewLabItemStyle ID" style="text-align:center; display:none;"><#=objRow.ID#></td>
            <td  class="GridViewLabItemStyle" style="text-align:center;">  
                &nbsp;&nbsp; &nbsp;&nbsp; 
                  <a href="#" id="A1"  onclick="ViewEmployee('<#=objRow.ID#>','<#=objRow.Name#>',this)">                      
                     <img style="width: 15px;" src="../../App_Images/view.gif" /></a> 

            </td>
                 <td  class="GridViewLabItemStyle" style="text-align:center;">
&nbsp;&nbsp; &nbsp;&nbsp; 
                <a href="#" onclick="AddEmployee('<#=objRow.ID#>','<#=objRow.Name#>','<#=objRow.SequenceNo#>',this)" >                      
                     <img style="width: 15px;" src="../../App_Images/plus.png" /></a>
                     </td>
                
            </tr> 
                 
      <#}#>

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
                    <td> Designation :&nbsp;<span id="lblviewDeginationName"></span></td>                   
                    <td  style="text-align:right">      
                        <img id="closeEmployee" alt="1" src="../../App_Images/Delete.gif"  style="cursor:pointer;" />  
                    </td>
                    
                </tr>
            </table>   

      </div>
              <table style="width: 100%;border-collapse:collapse">
                
                  <tr>
                      <td>
            <div id="div_Employies" style="text-align:center;width: 99%; max-height:450px;overflow-y:scroll;">
                
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
			<th class="GridViewHeaderStyle" scope="col" style="width:70px;">Mobile No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Email</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Delete</th>
             
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
	  <td id="td6" class="GridViewLabItemStyle"><a  href="#" id="DeleteEmp" onclick="DeleteEmp('<#=objRow.Employee_ID#>',this);">Delete</a></td>
     
</tr>
            <#}#>
     </table>    
    </script>


      <asp:Button ID="btnaddEmp" runat="server" Style="display:none" />
    <cc1:ModalPopupExtender ID="AddEmployee" runat="server"
                            DropShadow="true" TargetControlID="btnaddEmp" CancelControlID="closeAddEmployee" BackgroundCssClass="filterPupupBackground"
                            PopupControlID="pnlAddEmp"  OnCancelScript="closeAddEmployee()"  BehaviorID="AddEmployee">
                        </cc1:ModalPopupExtender>  
    <asp:Panel ID="pnlAddEmp" runat="server" Style="display: none;width:460px; height:292px; " CssClass="pnlVendorItemsFilter"> 
             <div  class="Purchaseheader">
        <table style="width:100%; border-collapse:collapse" border="0">                                                  
                <tr> 
                    <td> Designation :&nbsp;<span id="lbladdDesignation"></span>

                    </td>                   
                    <td  style="text-align:right">      
                        <img id="closeAddEmployee" alt="1" src="../../App_Images/Delete.gif"  style="cursor:pointer;" />  
                    </td>
                    
                </tr>
            </table>     
      </div>
                        <div>
                            <div style="text-align:center;"><asp:Label ID="lblerrmsg" runat="server" Text=""  CssClass="ItDoseLblError"></asp:Label></div>
                               
      <table id="TBMain"  style="width: 100%;border-collapse:collapse" >
                        
                         <tr>
                            <td style="width: 20%; padding-top: 10px;" align="right">
                                Search Employee :&nbsp;</td>
                            <td style="width: 20%; padding-top: 10px;" align="left">
                                <asp:TextBox ID="txtEmployee" runat="server"  Width="250px"></asp:TextBox>
                                <input type="hidden" value="0" id="hdnempid" />
                                <input type="hidden" value="0" id="hdnaddDesignationID" />
                                <input type="hidden" value="0" id="hdnaddDesignationSequence" />
                                
                              </td> 
                        </tr>
                        
             

           <tr id="to">
                            <td style="width: 20%;padding-top: 10px;" align="right">
                                Reporting TO :&nbsp;</td>
                            <td style="width: 21%; padding-top: 10px;" align="left">
                                        <asp:DropDownList ID="ddlreporingto" runat="server" CssClass="chosen-select" onchange="bindReporingEmployee(1)" Width="250px" >
                                        </asp:DropDownList>
                              </td> 
                        </tr>
          
           <tr id="toname">
                            <td style="width: 12%; padding-top: 10px;" align="right">
                                Reporting Name :&nbsp;</td>
                            <td style="width: 20%; padding-top: 10px;" align="left">
                                
                                          <asp:DropDownList ID="ddlreportingname" CssClass="chosen-select" onchange="bindTagHierarchy()" runat="server" Width="250px">
                                        </asp:DropDownList>
                              </td> 
                        </tr>
           <tr class="trTagLocation">
                            <td style="width: 20%;padding-top: 10px;text-align:right" >
                                Location Hierarchy :&nbsp;
                               
                            </td>
                            <td style="width: 21%; padding-top: 10px;text-align:left" >
 <asp:DropDownList ID="ddlLocationHierarchy" CssClass="chosen-select" onchange="bindTagLocation()" runat="server" Width="250px">
                                        </asp:DropDownList>
                              </td> 
                        </tr>


                        <tr class="trTagLocation" id="allTagLocation">
                            <td style="width: 20%;padding-top: 10px;text-align:right" >
                                Tag Location :&nbsp;
                                
                               
                            </td>
                            <td style="width: 21%; padding-top: 10px;text-align:left" >
                                        <asp:ListBox ID="lstTagLocation" CssClass="multiselect" SelectionMode="Multiple" Width="250px" runat="server" ClientIDMode="Static"></asp:ListBox>

                              </td> 
                        </tr>
                      <tr>
                          <td colspan="2">
                              &nbsp;
                          </td>
                      </tr>
                        
                    </table> 
    </div>
   <div style="text-align:center;width:100%; padding-top:5px; padding-bottom:5px;">        
      <button id="btnSave" type="button" class="searchbutton" onclick="SaveTest()" style="width:80px;">Save</button>             
   </div> 
       <div id="empautolist"></div>
    </asp:Panel>

</div>

    <script type="text/javascript">
        var ViewData = "";
        var EmpData = "";
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

            jQuery('#<%=ddlreporingto.ClientID%>').trigger('chosen:updated');
            jQuery('#<%=ddlreportingname.ClientID%>').trigger('chosen:updated');
            
            BindData();
            jQuery('[id*=lstTagLocation]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false,
                maxHeight: 200
            });
        });

        function BindData() {

            jQuery.ajax({
                url: "DesignationEmployeeMaster.aspx/GetDesignation",
                data: {}, // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    ViewData = jQuery.parseJSON(result.d);
                    var output = $('#tb_InvestigationItems').parseTemplate(ViewData);
                    jQuery('#div_InvestigationItems').html(output);
                    jQuery('#tb_grdLabSearch tr:even').addClass("GridViewAltItemStyle");
                },
                error: function (xhr, status) {

                }
            });

        }
  </script>
    <script type="text/javascript">
        function SaveTest() {
            if (IsVailid() == "1") {
                return;
            }
            $("#btnSave").attr('disabled', 'disabled').text("Saving...");
            var ReporterID = 0; 
            if (jQuery.trim(jQuery('#hdnaddDesignationSequence').val()) != "1") {

                ReporterID = jQuery('#<%=ddlreportingname.ClientID%>').val().split('#')[0];
                
            }
            var TypeID = "";
            if (jQuery(".trTagLocation").is(':visible')) {
                TypeID = jQuery('#lstTagLocation').multipleSelect("getSelects").join();
            }
            var tagLocationID = 1; var tagLocationName = "ALL";
            if (jQuery.trim(jQuery('#hdnaddDesignationSequence').val()) != 1) {
                tagLocationID = jQuery("#ddlLocationHierarchy").val();
                tagLocationName = jQuery("#ddlLocationHierarchy option:selected").text()
            }
            jQuery.ajax({
                url: "DesignationEmployeeMaster.aspx/Save",
                data: '{EmpID:"' + jQuery('#hdnempid').val() + '",DesignationID:"' + jQuery('#hdnaddDesignationID').val() + '",DesignationSequence:"' + jQuery.trim(jQuery('#hdnaddDesignationSequence').val()) + '",tagLocationID:"' + tagLocationID + '",tagLocationName:"' + tagLocationName + '",TypeID:"' + TypeID + '",ReporterID:"' + ReporterID + '"}', // parameter map
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        $("#btnSave").removeAttr('disabled').text("Save");
                        clear();
                        BindData();
                        jQuery('#<%=lblerrmsg.ClientID%>').html('Record Saved Successfully.');
                    }

                    else {
                        jQuery('#<%=lblerrmsg.ClientID%>').html('Record Not Saved.');
                        $("#btnSave").removeAttr('disabled').text("Save");
                    }
                },
                error: function (xhr, status) {
                    jQuery('#<%=lblerrmsg.ClientID%>').html('Error has occurred Record Not saved .');
                    $("#btnSave").removeAttr('disabled').text("Save");
                }
            });


        }

            function IsVailid() {
                var con = 0;
                if (jQuery.trim(jQuery('#<%=txtEmployee.ClientID %>').val()) == "") {
                    jQuery('#<%=lblerrmsg.ClientID%>').html("Please Search Employee.");
                    jQuery('#<%=txtEmployee.ClientID%>').focus();
                    con = 1;
                    return con;
                }
                if (jQuery.trim(jQuery('#hdnempid').val()) == "0" || jQuery.trim(jQuery('#hdnempid').val()) == "") {
                    jQuery('#<%=lblerrmsg.ClientID%>').html("Please Search Employee.");
                    jQuery('#<%=txtEmployee.ClientID%>').focus();
                    con = 1;
                    return con;
                }
                if ((jQuery.trim(jQuery('#<%=ddlreporingto.ClientID %>').val()) == "" || jQuery.trim(jQuery('#<%=ddlreporingto.ClientID %>').val()) == "0") && jQuery.trim(jQuery('#hdnaddDesignationSequence').val()) != "1") {
                    jQuery('#<%=lblerrmsg.ClientID%>').html("Please select Reporting TO.");
                    jQuery('#<%=ddlreporingto.ClientID%>').focus();
                    con = 1;
                    return con;
                }
                if ((jQuery.trim(jQuery('#<%=ddlreportingname.ClientID %>').val()) == "" || jQuery.trim(jQuery('#<%=ddlreportingname.ClientID %>').val()) == "0") && jQuery.trim(jQuery('#hdnaddDesignationSequence').val()) != "1") {
                    jQuery('#<%=lblerrmsg.ClientID%>').html("Please Select Reporting Name.");
                    jQuery('#<%=ddlreportingname.ClientID%>').focus();
                    con = 1;
                    return con;
                }

                if (jQuery("#ddlLocationHierarchy").is(':visible') && jQuery("#ddlLocationHierarchy").val() == 0) {
                    showerrormsg('Please Select Location Hierarchy');
                    jQuery("#ddlLocationHierarchy").focus();
                    con = 1;
                    return con;
                }
                

                if (jQuery("#lstTagLocation").is(':visible') && jQuery("#lstTagLocation :selected").length == 0) {
                    showerrormsg('Please Select Tag Location');
                    jQuery("#lstTagLocation").focus();
                    con = 1;
                    return con;

                }
                
               
                return con;
            }
            function clear() {
                jQuery("#hdnempid").val('0');
                jQuery("#<%=txtEmployee.ClientID%>").val('');
                jQuery("#<%=ddlreporingto.ClientID%>").val('0');
                jQuery("#<%=ddlreportingname.ClientID%> option").remove();               
                jQuery('#<%=ddlreporingto.ClientID%>').trigger('chosen:updated');
                jQuery('#<%=ddlreportingname.ClientID%>').trigger('chosen:updated');
                jQuery('#<%=lstTagLocation.ClientID%> option').remove();
                jQuery('#lstTagLocation').multipleSelect("refresh");
                jQuery('#<%=lblerrmsg.ClientID%>').text('');
                jQuery("#<%=ddlLocationHierarchy.ClientID%> option").remove();
                jQuery('#<%=ddlLocationHierarchy.ClientID%>').trigger('chosen:updated');
            }
    </script> 
    <script type="text/javascript">
	function DeleteEmp(EmployeeID, ctrl) {

            jQuery.ajax({
                url: "DesignationEmployeeMaster.aspx/DeleteEmployee",
                data: '{DesignationID:"' + $('[id$=hdnDesignationId]').val() + '",EmployeeId:"' + EmployeeID + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    if (result = "1") {
                        alert('Deleted Sucessfully');
                        ViewEmployee($('[id$=hdnDesignationId]').val(), '', '');
                        BindData();
                    }
                },
                error: function (xhr, status) {
                }
            });

        }
        function ViewEmployee(ID, Name, e) {
			$('[id$=hdnDesignationId]').val(ID);
            jQuery('#lblviewDeginationName').text(Name);
            jQuery.ajax({
                url: "DesignationEmployeeMaster.aspx/GetEmployee",
                data: '{DesignationID:"' + ID + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    EmpData = jQuery.parseJSON(result.d);
                    var output = $('#tb_Employee').parseTemplate(EmpData);
                    $('#div_Employies').html(output);
                    $('#tbl_Employee tr:even').addClass("GridViewAltItemStyle");
                },
                error: function (xhr, status) {

                }
            });

            $find('Employeepop').show();
        }
        function closeEmployee() {
            $('#div_Employies').html('');

            $find('Employeepop').hide();
        }

        function closeAddEmployee() {
            jQuery("#toname").show();
            jQuery("#to").show();
            jQuery('#lbladdDesignation').text("");
            jQuery('#hdnaddDesignationID').val("0");
            jQuery('#hdnaddDesignationSequence').val("0");
            jQuery('#<%=lblerrmsg.ClientID%>').html("");
            clear();
            $find('AddEmployee').hide();
        }
        function AddEmployee(DesignationID, DesignationName, Sequence, e) {
            jQuery('#lbladdDesignation').text(DesignationName);
            jQuery('#hdnaddDesignationID').val(DesignationID);
            jQuery('#hdnaddDesignationSequence').val(Sequence);
            if (Sequence != "1") {
                bindReporingDesignation(Sequence);
                bindReporingEmployee(0);
            }
            if (Sequence == "1") {
                jQuery("#toname").hide();
                jQuery("#to").hide();
            }
            else {
                jQuery("#toname").show();
                jQuery("#to").show();
            }
            if (Sequence == "1") {
                jQuery(".trTagLocation").hide();
                
            }
            else {
                jQuery(".trTagLocation").show();


            }
           
            
           
           

            $find('AddEmployee').show();

        }
        function onSucessTagLocation(result) {
            TagLocation = jQuery.parseJSON(result);
            if (TagLocation != null) {

                for (var i = 0; i < TagLocation.length; i++) {
                    jQuery('#lstTagLocation').append($("<option></option>").val(TagLocation[i].ID).html(TagLocation[i].Name));
                }
                jQuery('[id*=lstTagLocation]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
                jQuery('#lstTagLocation').multipleSelect("refresh");
               
            }
        }
        function onFailureTagLocation(result) {

        }

    </script> 
    
     <script type="text/javascript">
         function bindReporingDesignation(Sequence) {
             jQuery('#<%=lblerrmsg.ClientID%>').html("");
             jQuery("#<%=ddlreporingto.ClientID %> option").remove();
            
             jQuery.ajax({
                 url: "DesignationEmployeeMaster.aspx/bindDesignation",
                 data: '{Sequence:"' + Sequence + '"}', // parameter map
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 async: false,
                 success: function (result) {
                     var Designation = jQuery.parseJSON(result.d);
                     if (Designation.length == 0) {
                         $("#<%=ddlreporingto.ClientID %>").append($("<option></option>").val("0").html("---No Data Found---"));
                     }
                     else {
                         $("#<%=ddlreporingto.ClientID %>").append($("<option></option>").val("0").html("---Select---"));
                         for (i = 0; i < Designation.length; i++) {
                             $("#<%=ddlreporingto.ClientID %>").append($("<option></option>").val(Designation[i].ID).html(Designation[i].Name));
                         }
                     }
                     $("#<%=ddlreporingto.ClientID %>").trigger('chosen:updated');
                 },
                 error: function (xhr, status) {

                 }
             });
         }


         function bindReporingEmployee(con) {
             jQuery('#<%=lblerrmsg.ClientID%>').html("");
             jQuery("#<%=ddlreportingname.ClientID %> option").remove();
             jQuery("#<%=ddlLocationHierarchy.ClientID %> option").remove();
             jQuery("#<%=ddlreportingname.ClientID %>,#<%=ddlLocationHierarchy.ClientID %>").trigger('chosen:updated');
             jQuery('#<%=lstTagLocation.ClientID%> option').remove();
             jQuery('#lstTagLocation').multipleSelect("refresh");
             if ($("#<%=ddlreporingto.ClientID %>").val() != 0) {
                 jQuery.ajax({
                     url: "DesignationEmployeeMaster.aspx/bindReporter",
                     data: '{DesignationID:"' + jQuery('#<%=ddlreporingto.ClientID %>').val() + '"}', 
                     type: "POST",    	        
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     success: function (result) {
                         var ReportinEmployee = jQuery.parseJSON(result.d);
                         if (ReportinEmployee.length == 0) {
                             $("#<%=ddlreportingname.ClientID %>").append($("<option></option>").val("0").html("---No Data Found---"));
                         }
                         else {
                             $("#<%=ddlreportingname.ClientID %>").append($("<option></option>").val("0").html("---Select---"));
                             for (i = 0; i < ReportinEmployee.length; i++) {
                                 $("#<%=ddlreportingname.ClientID %>").append($("<option></option>").val(ReportinEmployee[i].Employee_ID).html(ReportinEmployee[i].EmpName));
                             }
                         }
                         jQuery("#<%=ddlreportingname.ClientID %>").trigger('chosen:updated');
                         
                     },
                     error: function (xhr, status) {

                     }
                 });
             }
          }
     </script>
    
    <script type="text/javascript">
        function bindTagLocation() {
            jQuery('#lstTagLocation option').remove();
            jQuery('#lstTagLocation').multipleSelect("refresh");
            if (jQuery('#ddlLocationHierarchy').val() == "1") {
                jQuery('#allTagLocation').hide();

            }
            else if (jQuery('#<%=ddlreportingname.ClientID %>').val() != 0 && jQuery('#ddlLocationHierarchy').val() != 0) {

                jQuery('.trTagLocation,#allTagLocation').show();
                PageMethods.bindTagLocation(jQuery('#<%=ddlreportingname.ClientID %>').val().split('#')[1], jQuery('#<%=ddlreportingname.ClientID %>').val().split('#')[0], jQuery('#ddlLocationHierarchy').val(), onSucessTagLocation, onFailureTagLocation);


                // }
            }
            else {


                
            }
        }
        jQuery(function () {
            jQuery("#<%=txtEmployee.ClientID%>").autocomplete({
          source: function (request, response) {
              $.ajax({
                  type: "POST",
                  contentType: "application/json; charset=utf-8",
                  url: "DesignationEmployeeMaster.aspx/SearchEmployee",
                  data: "{'query':'" + jQuery("#<%=txtEmployee.ClientID%>").val() + "'}",
                  dataType: "json",
                  success: function (data) {
                      var result = $.parseJSON(data.d);
                      response(result);

                  },
                  Error: function (results) {
                      alert("Error");
                  }
              });
          },
          focus: function () {
              // prevent value inserted on focus
              return false;
          },
          select: function (event, ui) {
              jQuery("#hdnempid").val(ui.item.value);
              jQuery("#<%=txtEmployee.ClientID%>").val(ui.item.label);
              return false;
          },
          appendTo: "#empautolist"

      });
  });
  </script>
    <script type="text/javascript">
        function bindTagHierarchy() {
            jQuery("#ddlLocationHierarchy option").remove();
            jQuery("#ddlLocationHierarchy").trigger('chosen:updated'); 
            if (jQuery("#ddlreportingname").val() != 0) {                               
                PageMethods.bindLocationHierarchy(jQuery("#ddlreportingname").val().split('#')[1], onSucessTagHierarchy, onFailureTagLocation);
            }
        }
        function onSucessTagHierarchy(result) {
           
            if (result != "") {
                var TagHierarchy = jQuery.parseJSON(result);

                jQuery("#ddlLocationHierarchy").append($("<option></option>").val("0").html("---Select---"));
                for (i = 0; i < TagHierarchy.length; i++) {
                    jQuery("#ddlLocationHierarchy").append($("<option></option>").val(TagHierarchy[i].ID).html(TagHierarchy[i].tagLocationName));
                }

                jQuery("#ddlLocationHierarchy").trigger('chosen:updated');
            }


        }
    </script>
        
<style type="text/css">
    .chosen-container {
        width:250px!important;
    }
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
   
</asp:Content>

