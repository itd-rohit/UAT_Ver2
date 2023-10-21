<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" EnableEventValidation="false"  
CodeFile="ItemMasterInterface.aspx.cs" Inherits="Design_Interfacer_ItemMasterInterface"  %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
            <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
     <%: Scripts.Render("~/bundles/confirmMinJS") %>

    
 <div id="Pbody_box_inventory" >
     <Ajax:ScriptManager AsyncPostBackErrorMessage="Error..." ID="ScriptManager1" EnablePageMethods="true" runat="server">
  
     </Ajax:ScriptManager> 
   <div class="POuter_Box_Inventory"  style="text-align:center">
    <b>Item Master Interface</b><br />
      <asp:Label ID="lblerrmsg" runat="server" ForeColor="#FF0033"></asp:Label>

  </div>
   <div class="POuter_Box_Inventory">
    <div class="Purchaseheader">Map Item Master Interface</div>        
        <div class="row">           
             <div class="col-md-5">			  
		   </div>	
            <div class="col-md-3">
			   <label class="pull-left">Interface Company</label>
			  <b class="pull-right">:</b>
		   </div>	  
		   <div class="col-md-6">
               <asp:DropDownList ID="ddlCompany" runat="server" class="ddlCompany  chosen-select" onchange="BindData()" >                                 
                               </asp:DropDownList>
                   </div>	  
            </div>	  
        <div class="row">           
             <div class="col-md-5">			  
		   </div>	
            <div class="col-md-3">
			   <label class="pull-left">Department</label>
			  <b class="pull-right">:</b>
		   </div>	  
		   <div class="col-md-6">
               <asp:DropDownList ID="ddlDepartment" runat="server" class="ddlDepartment  chosen-select" onchange="GetDepartmentItem()"> </asp:DropDownList>                                     
                        </div>	  
            </div>	  
       <div class="row">            
             <div class="col-md-5">			  
		   </div>	
            <div class="col-md-3">
			   <label class="pull-left">Items</label>
			  <b class="pull-right">:</b>
		   </div>	  
		   <div class="col-md-6">
               <asp:DropDownList ID="ddlItem" runat="server"  class="ddlItem  chosen-select"  
                                    > </asp:DropDownList>
               </div>
           </div>
       <div class="row">          
             <div class="col-md-5">			  
		   </div>	
            <div class="col-md-3">
			   <label class="pull-left">Interface TestCode</label>
			  <b class="pull-right">:</b>
		   </div>	  
		   <div class="col-md-6">
               <asp:TextBox ID="txttestcode" runat="server"  MaxLength="20"></asp:TextBox>
               </div>
            </div>
        <div class="row">            
             <div class="col-md-5">			  
		   </div>	
            <div class="col-md-3">
			   <label class="pull-left">Itnterface TestName</label>
			  <b class="pull-right">:</b>
		   </div>	  
		   <div class="col-md-6">
               <asp:TextBox ID="txttestname" runat="server"  MaxLength="100"></asp:TextBox>
               </div>
                  </div>                         
   </div> 
   <div class="POuter_Box_Inventory"  style="text-align:center">        
      <button id="btnSave" type="button"  onclick="SaveTest()" >Save</button>             
   </div>
   <div class="POuter_Box_Inventory" style="text-align:center">         
              <asp:Button ID="btnexport" runat="server"  Text="Export to excel"  OnClick="btnexport_Click" />  
         <button id="btnshowmaping" type="button" onclick="showMaping()" >Show Mapping</button>          
     <div id="div_InvestigationItems"  style="max-height:800px; overflow-y:auto; overflow-x:hidden; display:none;">       
        </div>      
   </div>     
   <script id="tb_InvestigationItems" type="text/html">     
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch" style="border-collapse:collapse;width:100%;">
		<tr >
			<th class="GridViewHeaderStyle" scope="col" style="width:30px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">ItemID</th>			
			<th class="GridViewHeaderStyle" scope="col" style="width:70px;">Test Code</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Test Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Department</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Interface ItemID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Interface ItemName</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:120px;">Interface Company</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:70px;">CreatedBy</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:70px;">Creation Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:70px;">UpdatedBy</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:70px;">Updated Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:70px;">Status</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:70px;">Change Status</th>
       
        </tr>

       <#
       
              var dataLength=ViewData.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {            

        objRow = ViewData[j];
                 #>
            <tr  
                <#if(objRow.IsActive=="Deactive"){#>
                      style="background-color: lightgray;color: #000;"
                      <#} 
                 else{#>
                        style="background-color:White;"
                         <#}
                #> 
                >
            <td class="GridViewLabItemStyle" style="text-align:center;" ><#=j+1#></td>
            <td  class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.ItemID#></td>
            <td  class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.TestCode#></td>
            <td  class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.TypeName#></td>
            <td  class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.Department#></td>
            <td  class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.ItemID_interface#></td>
            <td class="GridViewLabItemStyle"  style=" text-align:center"><#=objRow.ItemName_interface#></td>
            <td class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.Interface_companyName#></td>
            <td class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.CreatedBy#></td>
            <td class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.EntryDate#></td>
            <td class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.UpdatedBy#></td>
            <td class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.UpdatedDate#></td>
            <td class="GridViewLabItemStyle" id="lblstatus" style="text-align:center;"><#=objRow.IsActive#></td>          
             <td class="GridViewLabItemStyle" style="text-align:center;" >
                 
                 <a href="#" id="btndeactive"  onclick="UpdateStatus('<#=objRow.ID#>','0',this)"
                      <#if(objRow.IsActive=="Deactive"){#>
                      style="display:none"
                      <#} #>>
                     <img style="width: 15px;" src="../../App_Images/Delete.gif" /></a>                                  
                 <a href="#" id="btnactive"  onclick="UpdateStatus('<#=objRow.ID#>','1',this)"
                       <#if(objRow.IsActive=="Active"){#>
                      style="display:none"
                      <#} #>>
                     <img style="width: 15px;" src="../../App_Images/Post.gif" /></a>                   
             </td> 
            </tr>    
      <#}#>

        </table>    
    </script> 
</div>
    <script type="text/javascript">
        $(function () {
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
        var ViewData = "";
        function bindlist() {           
            serverCall('ItemMasterInterface.aspx/GetTest', { CompanyID: $("#<%=ddlCompany.ClientID %>").val() }, function (response) {
                ViewData = jQuery.parseJSON(response);
                var output = $('#tb_InvestigationItems').parseTemplate(ViewData);
                $('#div_InvestigationItems').html(output);
                $("#tb_grdLabSearch :text").hide();
                $('#tb_grdLabSearch tr:even').addClass("GridViewAltItemStyle");
            });           
        }
  </script> 
    <script type="text/javascript">
        function GetDepartmentItem() {
            $("#<%=ddlItem.ClientID %> option").remove();
            var ddlItem = $("#<%=ddlItem.ClientID %>");
            serverCall('ItemMasterInterface.aspx/bindItems', { SubCategoryID: $("#<%=ddlDepartment.ClientID %>").val(), billcategory: "0" }, function (response) {
                var ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    ddlItem.append($("<option></option>").val("0").html("---No Data Found---"));
                }
                else {
                    ddlItem.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ItemID', textField: 'TypeName', isSearchAble: true });                   
                }
            });           
        }
        function BindData() {
            if ($("#div_InvestigationItems").is(':visible')) {
                bindlist();
            }
        }
    </script>    
    <script type="text/javascript">
        var IsUpdate = false;
        function SaveTest() {
            if (IsVailid() == "1") {
                return;
            }
            $("#btnSave").attr('disabled', 'disabled').text("Saving...");
            serverCall('ItemMasterInterface.aspx/saveTest', { ItemID: jQuery('#<%=ddlItem.ClientID %> option:selected').val(), TestCode: jQuery('#<%=ddlItem.ClientID %> option:selected').text(), ItemID_interface: jQuery('#<%=txttestcode.ClientID %>').val(), ItemName_interface: jQuery('#<%=txttestname.ClientID %>').val(), Interface_companyName: jQuery('#<%=ddlCompany.ClientID %> option:selected').text(), Interface_CompanyID: jQuery('#<%=ddlCompany.ClientID %> option:selected').val(), IsUpdate: IsUpdate }, function (response) {
                IsUpdate = false;
                if (response == "1") {
                    toast('Success', 'Record Saved Successfully.');
                         clear();
                         BindData();
                     }
                else if (response == "2") {
                         IsUpdate = false;
                         toast('Error', 'Mapping already exists');
                     }
                else if (response == "3") {
                    toast('Error', 'Mapping already exists in deactive mode.');
                    $confirmationBox("Mapping already exists in deactive mode. Do you want to make it active ?", ID, Status, 1)


                }
                else if (response == "4") {
                    toast('Error', 'This Interface Company use itdose testID so mapping not required');
                }
                else {
                    toast('Error', 'Record Not Saved.');

                }
                $("#btnSave").removeAttr('disabled').text("Save");
            });
            

            }

            function IsVailid() {
                var con = 0;
                if (jQuery.trim(jQuery('#<%=ddlCompany.ClientID %> option:selected').val()) == "") {
                    toast('Error', "Please Select Interface Company.");
                jQuery('#<%=ddlCompany.ClientID%>').focus();
                con = 1;
                return con;
            }
            if (jQuery.trim(jQuery('#<%=ddlDepartment.ClientID %> option:selected').val()) == "") {
                toast('Error', 'Please Select Department .');
                jQuery('#<%=ddlDepartment.ClientID %>').focus();
                con = 1;
                return con;
            }

            if (jQuery.trim(jQuery.trim(jQuery('#<%=ddlItem.ClientID %>').val())) == "") {
                toast('Error', 'Please Select Items .');
                jQuery('#<%=ddlItem.ClientID %>').focus();
                con = 1;
                return con;
            }

            if (jQuery.trim(jQuery('#<%=txttestcode.ClientID %>').val()) == "") {
                toast('Error', 'Please Enter Test Code .');
                jQuery('#<%=txttestcode.ClientID %>').focus();
                con = 1;
                return con;
            }
            if (jQuery.trim(jQuery('#<%=txttestname.ClientID %>').val()) == "") {
                toast('Error', 'Please Enter Test Name .');
                jQuery('#<%=txttestname.ClientID %>').focus();
                con = 1;
                return con;
            }
        }

        function clear() {
            $('#<%= txttestcode.ClientID%>').val('');
            $('#<%= txttestname.ClientID%>').val('');
            jQuery("#<%= ddlItem.ClientID%> option").remove();
            $('#<%= ddlItem.ClientID%>').val('').trigger('chosen:updated');
            jQuery("#<%= ddlDepartment.ClientID%>").prop('selectedIndex', 0);
            $('#<%= ddlDepartment.ClientID%>').val('').trigger('chosen:updated');
        }
    </script> 
    <script type="text/javascript">
        $confirmationBox = function (contentMsg, ID, Status,type) {
            jQuery.confirm({
                title: 'Confirmation!',
                content: contentMsg,
                animation: 'zoom',
                closeAnimation: 'scale',
                useBootstrap: false,
                opacity: 0.5,
                theme: 'light',
                type: 'red',
                typeAnimated: true,
                boxWidth: '480px',
                buttons: {
                    'confirm': {
                        text: 'Yes',
                        useBootstrap: false,
                        btnClass: 'btn-blue',
                        action: function () {
                            if (type == 0)
                                $confirmationAction(ID, Status);
                            else {
                                IsUpdate = true;
                                SaveTest();
                            }
                        }
                    },
                    somethingElse: {
                        text: 'No',
                        action: function () {
                           
                        }
                    },
                }
            });
        }
        $confirmationAction = function (ID, Status) {
            serverCall('ItemMasterInterface.aspx/UpdateStatus', { ID: ID, Status: Status }, function (response) {
                if (response == "1") {
                  toast('Success','Record Updated Successfully');
                    bindlist();
                }
                else {
                    toast('Error', 'Error has occured Record Not Deactivated .');
                }
            });
            
        }
        function showMaping() {
            if (!$("#div_InvestigationItems").is(':visible')) {
                bindlist();
                $('#btnshowmaping').text('Hide Mapping')
            }
            else {
                $('#btnshowmaping').text('Show Mapping')
            }
            $('#div_InvestigationItems').slideToggle();
        }


        function UpdateStatus(ID, Status, ctrl) {
            var _status = "";
            if (Status == "0")
                _status = " Deactive";
            else
                _status = " Active";
            $confirmationBox("Are you sure to " + _status + " this.", ID, Status,0)
            

            }


    </script>      
<style type="text/css">
    .GridViewHeaderStyle {
        height: 25px!important;
    }

    [type=text], select {
        padding: 5px 5px;
        margin: 0px 0;
        display: inline-block;
        border: 1px solid #ccc;
        border-radius: 5px;
        box-sizing: border-box;
    }

    input[type="button"] {
        outline: none;
    }


    .btn {
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

        .btn:hover, .btn:focus, .btn:active, .btn.active, .btn.disabled, .btn[disabled] {
            color: #333333;
            background-color: #e6e6e6;
            *background-color: #d9d9d9;
        }

        .btn:active, .btn.active {
            background-color: #cccccc;
        }

        .btn:hover, .btn:focus {
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

