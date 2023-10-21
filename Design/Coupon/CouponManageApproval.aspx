<%@ Page  ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CouponManageApproval.aspx.cs" Inherits="Design_Coupon_CouponManageApproval" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
       <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
    
    <script src="../../Scripts/jquery-confirm.min.js" type="text/javascript"></script> 
    <div id="Pbody_box_inventory" >
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
           
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <strong>Manage Approval<br />
            </strong>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"  />           
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Select Approval
            </div>
            <div class="row">
            <div class="col-md-3">
                    <label class="pull-left">Employee Name  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                      <asp:TextBox ID="txtEmployee" runat="server" CssClass="requiredField" ></asp:TextBox>
                        <input id="hdEmployeeID" type="hidden" value="0" />
                    </div>
            </div>
              <div class="row">
            <div class="col-md-3">
                    <label class="pull-left">Authority Type  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlType" runat="server" onchange="searchApproval()">
                            <asp:ListItem Value="Coupon" Text="Coupon"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                  </div>

              <div class="row" style="display:none" id="trShowRate">
            <div class="col-md-3">
                    <label class="pull-left">Show Rate  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                      <asp:RadioButtonList ID="rblShowRate" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem  Value="0">No</asp:ListItem>
                            <asp:ListItem Value="1" Selected="True">Yes</asp:ListItem>                                                  
                        </asp:RadioButtonList>
                    </div>
           </div>
                   <div class="row">                      
            <div class="col-md-3">
                    <label class="pull-left">For Approval  </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-16">                           
                        <table id="chlApproval">
                            <tr>
		                   <td><input id="chlApproval_0" type="checkbox" value="0#Maker"/><label for="chlApproval_0">Maker</label>  </td>
                           <td><input id="chlApproval_1" type="checkbox" value="1#Checker"/><label for="chlApproval_1">Checker</label>  </td>
                           <td><input id="chlApproval_2" type="checkbox" value="2#Approval"/><label for="chlApproval_2">Approval</label>  </td>
                           <td><input id="chlApproval_3" type="checkbox" value="3#Reject"/><label for="chlApproval_3">Reject</label>  </td>
                           <td><input id="chlApproval_4" type="checkbox" value="4#StatusChange"/><label for="chlApproval_4">StatusChange</label>  </td>
                           <td><input id="chlApproval_5" type="checkbox" value="5#Edit"/><label for="chlApproval_5">Edit</label>  </td>
                           <td><input id="Checkbox1" type="checkbox" value="6#NotApproval"/><label for="chlApproval_6">NotApproval</label>  </td>
</tr>
                        </table>                      
                    </div>
                        </div>
        </div>
        <div class="POuter_Box_Inventory" style=" text-align: center">
              <input type="button" id="btnAdd" class="savebutton" value="Save" onclick="AddApproval()" />&nbsp;&nbsp;
                         <a onclick="exportReport()" class="searchbutton" id="btnexportReport" >Report
                  <img src="../../App_Images/xls.png" width="22" style="cursor:pointer;text-align:center" /></a>
            </div>
        <div class="POuter_Box_Inventory" style=" text-align: center">
            <div class="Purchaseheader">
                All Selected Approval&nbsp;
                 <a onclick="searchApproval()"  id="A1" style="color: blue;background-color: transparent; text-decoration: underline;cursor:pointer" >SearchAll</a>               
            </div>        
</div>                                     
        <div class="POuter_Box_Inventory" >  
     <div id="div_Approval"  style="max-height:433px; overflow-y:auto; overflow-x:hidden;">       
        </div>       
   </div>   
        <div id="divEmployeeList"></div>
    </div>      
    <script type="text/javascript">
        $(function () {
            searchApproval();
        });
        function AddApproval() {
            if (jQuery("#hdEmployeeID").val() == "" || jQuery("#txtEmployee").val() == "") {
                jQuery('#lblMsg').text('Please Enter Employee Name');
                jQuery("#txtEmployee").focus();
                return;
            }
            if (jQuery("#ddlType").val() == "0") {
                jQuery('#lblMsg').text('Please Select Authority Type');
                jQuery("#ddlType").focus();
                return;
            }
            var typeData = '';
            $("[id*=chlApproval] input:checked").each(function () {
                typeData += $(this).val() + ",";
            });
            if (typeData == '') {
                jQuery('#lblMsg').text('Please Select Approval...!');
                return false;
            }
            var applicablefor = "Coupon";
            serverCall('CouponManageApproval.aspx/SaveApprovalRight', { EmployeeID: jQuery("#hdEmployeeID").val(), typeData: typeData, appRightFor: jQuery("#ddlType").val() }, function (response) {
                if (response == "success") {
                    toast('Success', 'Record Saved Successfully');
                    jQuery('#hdEmployeeID,#txtEmployee').val('');
                    searchApproval();
                }
                else {
                    jQuery('#lblMsg').text(result);
                }
            });
        }
        function searchApproval() {
            jQuery('#lblMsg').text('');
            serverCall('CouponManageApproval.aspx/bindManageApproval', {}, function (response) {
                ApprovalData = jQuery.parseJSON(response);
                var output = jQuery('#sc_Approval').parseTemplate(ApprovalData);
                jQuery('#div_Approval').html(output);
            });
        }
        jQuery(function () {
            jQuery("#txtEmployee").autocomplete({
                autoFocus: true,
                source: function (request, response) {
                    serverCall('CouponManageApproval.aspx/SearchEmployee', { query: jQuery("#txtEmployee").val() }, function (result) {
                        var resultStatus = $.parseJSON(result);
                        response(resultStatus);
                    }, '', false);
                },
                focus: function () {
                    return false;
                },
                select: function (event, ui) {
                    jQuery("#hdEmployeeID").val(ui.item.value);
                    jQuery("#txtEmployee").val(ui.item.label);
                    return false;
                },
                appendTo: "#divEmployeeList"
            });
        });
    </script>
     <script id="sc_Approval" type="text/html" >      
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tbl_grdApproval" style="border-collapse:collapse;width:1260px;"> 
            <thead>
		<tr >			
		    <td class="GridViewHeaderStyle" style="width: 260px; text-align: center">Employee Name</td>
            <td class="GridViewHeaderStyle" style="width: 160px; text-align: center">Approval</td>
            <td class="GridViewHeaderStyle" style="width: 70px; text-align: center">Authority Type </td>
            <td class="GridViewHeaderStyle" style="width: 180px; text-align: center">Created By</td>
            <td class="GridViewHeaderStyle" style="width: 110px; text-align: center">Created Date</td>
            <td class="GridViewHeaderStyle" style="width: 70px; text-align: center">Remove</td>
        </tr>
                </thead>            
            <tbody>
       <#      
              var dataLength=ApprovalData.length;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {            
        objRow = ApprovalData[j];
                 #>            
            <tr >                                               
            <td  class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.EmployeeName#></td>
            <td  class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.TypeName#></td>
            <td  class="GridViewLabItemStyle Sequence" style="text-align:center;"><#=objRow.AppRightFor#></td>           
            <td  class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.CreatedBy#></td>
            <td  class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.CreatedDate#></td>
            <td  class="GridViewLabItemStyle" id="tdApprightID" style="text-align:center;display:none"><#=objRow.ApprightID#></td>
            <td  class="GridViewLabItemStyle" style="text-align:center;"><img style="cursor:pointer" src="../../App_Images/Delete.gif" onclick="removeApproval(this)" /> </td>   
                   
                       
            </tr>                  
      <#}#>
            </tbody>
        </table>    
    </script> 
    <script type="text/javascript">
        function removeApproval(rowID) {
            var ApprightID = jQuery(rowID).closest('tr').find('#tdApprightID').text();
            chkRemove('Do You Want to Remove', ApprightID);
        }
    </script>
        <script type="text/javascript">
            function chkRemove(contentMsg, ApprightID) {
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
                                confirmationAction(ApprightID);
                            }
                        },
                        somethingElse: {
                            text: 'No',
                            action: function () {
                                clearAction();
                            }
                        },
                    }
                });
            }
            function confirmationAction(ApprightID) {
                PageMethods.removeManageApproval(ApprightID, onsucessRemoveApproval, onFailureSearchApproval);
            }
            function clearAction() {

            }
            function onsucessRemoveApproval(result) {
                if (result == "1") {
                    searchApproval();
                    jQuery('#lblMsg').text('Record Updated Successfully');
                }
                else {
                    jQuery('#lblMsg').text('Record Not Saved');
                }

            }
            function exportReport() {
                PageMethods.exportToExcel(onsucessExportReport, onFailureSearchApproval);
            }
            function onsucessExportReport(result) {
                if (result == "0") {
                    jQuery('#lblMsg').text('No Record Found');
                }
                else if (result == "1") {
                    window.open('../common/ExportToExcel.aspx');

                }
            }
     </script>
</asp:Content>


