<%@ Page Title="" ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="QCApprovalRight.aspx.cs" Inherits="Design_Quality_QCApprovalRight" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
       <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
     <%: Scripts.Render("~/bundles/JQueryUIJs") %>
     <%: Scripts.Render("~/bundles/Chosen") %>
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
     <%: Scripts.Render("~/bundles/JQueryStore") %>
    <script src="../../Scripts/jquery-confirm.min.js" type="text/javascript"></script> 

    <div id="Pbody_box_inventory" style="width: 1304px;">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
           
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;width: 1300px;">

            <strong>Manage Approval Quality<br />
            </strong>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />           
        </div>
        <div class="POuter_Box_Inventory" style="width: 1300px; text-align: center">
            <div class="Purchaseheader">
                Select Approval
            </div>

            <table style="width: 100%; border-collapse: collapse">
                <tr style="text-align: right">
                    <td >Employee Name :&nbsp;</td>
                    <td style="text-align: left">
                       
                        <asp:TextBox ID="txtEmployee" runat="server" Width="280px"></asp:TextBox>
                        <input id="hdEmployeeID" type="hidden" value="0" />
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right">Authority Type :&nbsp;</td>
                    <td style="text-align: left">
                        <asp:DropDownList ID="ddlType" runat="server" Width="200px" onchange="searchApproval('0')"></asp:DropDownList></td>
                </tr>
                                            
            </table>

            <table style="width: 100%; border-collapse: collapse">
                 <tr>
                    <td style="text-align: right;font-weight:bold;width:285px">For Approval :&nbsp;</td>
                    <td style="text-align: left">                       
                        <table id="chlApproval">
		                   
                        </table>                      
                    </td>
                </tr>


                <tr>
                    <td style="text-align: center; font-weight: 700;" colspan="2">ILCSE - ILC Schedule Extend&nbsp;&nbsp;&nbsp; EQAS - EQAS Result Entry and Approval
                        &nbsp;&nbsp;&nbsp; CAP - CAP Result Entry and Approval
                    </td>
                </tr> 
            </table>
        </div>
        <div class="POuter_Box_Inventory" style="width: 1300px; text-align: center">
              <input type="button" id="btnAdd" class="savebutton" value="Add" onclick="AddApproval()" />&nbsp;&nbsp;
                         <a onclick="exportReport()" class="searchbutton" id="btnexportReport" >Report
                  <img src="../../App_Images/xls.png" width="22" style="cursor:pointer;text-align:center" /></a>
            </div>
        <div class="POuter_Box_Inventory" style="width: 1300px; text-align: center">
            <div class="Purchaseheader">
                All Selected Approval&nbsp;
                 <a onclick="searchApproval('1')"  id="A1" style="color: blue;background-color: transparent; text-decoration: underline;cursor:pointer" >SearchAll</a>               
            </div>        
</div>                                     
        <div class="POuter_Box_Inventory" style="width:1300px;">  
     <div id="div_Approval"  style="max-height:433px; overflow-y:auto; overflow-x:hidden;">       
        </div>       
   </div>   

        <div id="divEmployeeList"></div>
    </div>
    <script type="text/javascript">

        function openmypopup(href) {




            var width = '600px';

            $.fancybox({
                'background': 'none',
                'hideOnOverlayClick': true,
                'overlayColor': 'gray',
                'width': width,
                'height': '800px',
                'autoScale': false,
                'autoDimensions': false,
                'transitionIn': 'elastic',
                'transitionOut': 'elastic',
                'speedIn': 6,
                'speedOut': 6,
                'href': href,
                'overlayShow': true,
                'type': 'iframe',
                'opacity': true,
                'centerOnScroll': true,
                'onComplete': function () {
                },
                afterClose: function () {



                }
            });
        }
        function openupload() {
            if (jQuery("#hdEmployeeID").val() == "" || jQuery("#txtEmployee").val() == "") {
                jQuery('#lblMsg').text('Please Enter Employee Name');
                jQuery("#txtEmployee").focus();
                return;
            }
            openmypopup("uploadposign.aspx?empid=" + jQuery("#hdEmployeeID").val());

        }

        $(function () {
            // bindApprovalData();
            //AddMorePO();
        });
        function bindApprovalData(typeToBind) {
            $('#chlApproval tr').remove();
            $.ajax({
                url: "QCApprovalRight.aspx/bindaction",
                data: '{typeToBind:"' + typeToBind + '"}',
                contentType: "application/json; charset=utf-8",
                type: "POST", // data has to be Posted 
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    var ItemData = jQuery.parseJSON(result.d);

                    if (ItemData.length == 0) {
                        alert('No Action Found');
                        return;
                    }

                    var mydata = '<tr>';
                    for (i = 0; i < ItemData.length; i++) {
                        mydata += '<td>';


                        mydata += '<input id="chlApproval_' + ItemData[i].TypeIDApprove + '" type="checkbox" value="' + ItemData[i].TypeIDApprove + '#' + ItemData[i].typename + '"><label for="chlApproval_' + ItemData[i].TypeIDApprove + '">' + ItemData[i].typename + '</label>';

                        mydata += '</td>';

                    }
                    mydata += '</tr>';
                    $('#chlApproval').append(mydata);


                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                }
            });




        }


        function showpoapp(ctrl) {
            if ($(ctrl).is(':checked')) {
                $('#trpoapproval').show();
                $('#txtpolimitperpo').val('');
                $('#txtpolimitpermonth').val('');
            }
            else {
                $('#trpoapproval').hide();
                $('#txtpolimitperpo').val('');
                $('#txtpolimitpermonth').val('');

            }
        }
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
            //alert(typeData);
            if (typeData == '') {
                jQuery('#lblMsg').text('Please Select Approval...!');
                return false;
            }

            
            //jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
            PageMethods.SaveApprovalRight(jQuery("#hdEmployeeID").val(), typeData, jQuery("#ddlType").val(), onSucessApproval, onFailureApproval);
            //  PageMethods.SaveApprovalRight(jQuery("#hdEmployeeID").val(), jQuery("#chlApproval input[type=radio]:checked").val(), jQuery("#ddlType").val(), jQuery("#rblShowRate input[type=radio]:checked").val(), onSucessApproval, onFailureApproval);


        }
        function onSucessApproval(result) {
            if (result == "success") {
                alert('Record Saved Successfully');
                searchApproval('0');

            }
            else {
                jQuery('#lblMsg').text(result);
            }
            //jQuery.unblockUI();
        }
        function onFailureApproval(result) {
            //jQuery.unblockUI();
        }
        function searchApproval(con) {
            jQuery('#lblMsg').text('');
           
            $('#trpoapproval').hide();
            $('#txtpolimitperpo').val('');
            $('#txtpolimitpermonth').val('');
            if (con == "0" && jQuery("#ddlType").val() == 0) {
                jQuery('#div_Approval').html('');
                return;
            }
            //jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
            if (con == "1") {
                PageMethods.bindManageApproval('0', con, onsucessSearchApproval, onFailureSearchApproval);
            }
            else if (jQuery("#ddlType").val() != 0 && con == "0") {
                searchApproval();
                bindApprovalData(jQuery("#ddlType").val());
                PageMethods.bindManageApproval(jQuery("#ddlType").val(), con, onsucessSearchApproval, onFailureSearchApproval);
            }
            else {
                $('#chlApproval tr').remove();
                jQuery('#div_Approval').html('');
            }
        }
        
        function onsucessSearchApproval(result) {
            ApprovalData = jQuery.parseJSON(result);
            var output = jQuery('#sc_Approval').parseTemplate(ApprovalData);
            jQuery('#div_Approval').html(output);
            //jQuery.unblockUI();
        }
        function onFailureSearchApproval() {

        }
        jQuery(function () {
            jQuery("#<%=txtEmployee.ClientID%>").autocomplete({
                autoFocus: true,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "QCApprovalRight.aspx/SearchEmployee",
                        data: "{'query':'" + jQuery("#<%=txtEmployee.ClientID%>").val() + "'}",
                        dataType: "json",
                        success: function (data) {
                            var result = jQuery.parseJSON(data.d);
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
                    jQuery("#hdEmployeeID").val(ui.item.value);
                    jQuery("#<%=txtEmployee.ClientID%>").val(ui.item.label);
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
		    <td class="GridViewHeaderStyle" style=" text-align: left">Employee Name</td>
            <td class="GridViewHeaderStyle" style="text-align: left">Authority Type</td>
            <td class="GridViewHeaderStyle" style="text-align: left">Approval</td>
          
           
            <td class="GridViewHeaderStyle" style="width: 150px; text-align: left">Created By</td>
            <td class="GridViewHeaderStyle" style="width: 110px; text-align: left">Created Date</td>
            <td class="GridViewHeaderStyle" style="width: 70px; text-align: left">Remove</td>
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
            <td  class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.AppRightFor#></td>  
               
                    
            <td  class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.CreatedBy#></td>
            <td  class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.CreatedDate#></td>
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
                //jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
                PageMethods.removeManageApproval(ApprightID, onsucessRemoveApproval, onFailureSearchApproval);
            }
            function clearAction() {

            }
            function onsucessRemoveApproval(result) {
                if (result == "1") {
                    searchApproval('0');
                    jQuery('#lblMsg').text('Record Updated Successfully');
                }
                else {
                    jQuery('#lblMsg').text('Record Not Saved');
                }
                //jQuery.unblockUI();
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

