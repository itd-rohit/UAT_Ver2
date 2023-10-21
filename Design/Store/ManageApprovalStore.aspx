<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ManageApprovalStore.aspx.cs" Inherits="Design_Store_ManageApprovalStore" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <script src="../../Scripts/fancybox/jquery.fancybox.js"></script>
    <script src="../../Scripts/jquery-confirm.min.js" type="text/javascript"></script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Manage Approval</b>
          
        </div>
        <div class="POuter_Box_Inventory"  id="makerdiv">
            <div id="PatientDetails" class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="cursor: pointer;" ><%--onclick="showhide('1')"--%>
                    Select Approval
                </div>
                <div class="row" id="tab1" >
                   
                             <div class="col-md-6">
                            </div>
                             <div class="col-md-3 ">
                                 <label class="pull-left">Employee Name </label>
                                 <b class="pull-right">:</b>
                             </div>                           
                            <div class="col-md-6">
                                <asp:TextBox ID="txtEmployee" runat="server"></asp:TextBox>
                                <input id="hdEmployeeID" type="hidden" value="0" />
                            </div>
                            <div class="col-md-6">
                            </div>
                        </div>
                        <div class="row">
                             <div class="col-md-6">
                            </div>
                            <div class="col-md-3 ">
                                 <label class="pull-left">Authority Type </label>
                                 <b class="pull-right">:</b>
                             </div>                  
                          
                            <div class="col-md-6">
                                <asp:DropDownList ID="ddlType" runat="server" onchange="searchApproval('0')"></asp:DropDownList>
                            </div>
                            <div class="col-md-6">
                            </div>
                        </div>

                        <div class="row" style="display: none" id="trShowRate">
                             <div class="col-md-6">
                            </div>
                           <div class="col-md-3 ">
                                 <label class="pull-left">Show Rate </label>
                                 <b class="pull-right">:</b>
                             </div>  
                            <div class="col-md-6">
                                <asp:RadioButtonList ID="rblShowRate" runat="server" RepeatDirection="Horizontal">
                                    <asp:ListItem Value="0">No</asp:ListItem>
                                    <asp:ListItem Value="1" Selected="True">Yes</asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                            <div class="col-md-6">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3 ">
                                <label class="pull-left" style="text-align: right; font-weight: bold;">For Approval :   </label>
                            </div>
                            <div class="col-md-21">
                                <table id="chlApproval"></table>
                            </div>
                        </div>
                        <div class="row" style="display: none;" id="trpoapproval">
                            <div class="col-md-15">
                                <div class="col-md-11 ">
                                    <label class="pull-left" style="text-align: right; font-weight: bold;">Maxmimum Limit(Per PO) ₹ :   </label>
                                    <asp:TextBox ID="txtpolimitperpo" runat="server" MaxLength="7"></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" FilterType="Numbers" TargetControlID="txtpolimitperpo">
                                    </cc1:FilteredTextBoxExtender>
                                </div>
                                <div class="col-md-11 ">
                                    <label class="pull-left" style="text-align: right; font-weight: bold;">Maxmimum Limit(Per Month) ₹ :   </label>
                                    <asp:TextBox ID="txtpolimitpermonth" runat="server" MaxLength="7"></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Numbers" TargetControlID="txtpolimitpermonth">
                                    </cc1:FilteredTextBoxExtender>

                                </div>
                                <div class="col-md-2 ">
                                     <label class="pull-left" style="text-align: right; font-weight: bold;">&nbsp; </label>
                                <input type="button" value="Upload Sign" style="cursor: pointer; font-weight: 700;" onclick="openupload()" />
                            </div>
                            </div>
                            

                        </div>
                        <div class="row">
                            <div class="col-md-24 ">
                                <label style="text-align: left; font-weight: 600;">
                                    VQ - Vendor Quotation , PO - Purchase Order , VM-Vendor Master , IM - Item Master , PI - Purchase Indent , SI - Sales Indent , IS - Item Issue,POD-Proof OF Document<br />
                                    SPV- Stock Physical Verification , SR-Supplier Return</label>
                            </div>
                        </div>
                        <div class="row" style="text-align: center">
                            <div class="col-md-24 ">
                                <input type="button" id="btnAdd" class="savebutton" value="Add" onclick="AddApproval()" />
                                <input type="button" id="btnexportReport" class="searchbutton" value=" Excel Report" onclick="exportReport()" />
                                <%--<a onclick="exportReport()" class="searchbutton" id="btnexportReport">Report</a>--%><%--<img src="../../App_Images/xls.png" width="16" style="cursor: pointer; text-align: center; margin: 0px 0px 0px 10px" />--%>
                            </div>
                        </div>
                   
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center" id="Div1">
            <div id="Div2" class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="cursor: pointer;" onclick="showhide('1')">
                    All Selected Approval 
                    <a onclick="searchApproval('1')" id="A2" style="color: blue; background-color: transparent; text-decoration: underline; cursor: pointer">SearchAll</a>
                </div>
                <div class="row" id="Div3" style="margin-top: 0px;">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-24 ">
                                <div id="div_Approval" style="max-height: 433px; overflow-y: auto; overflow-x: hidden;">
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-24 ">
                                <div id="divEmployeeList"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    </div>
    <script type="text/javascript">
        var ApprovalData = "";
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

                toast("Error", "Please Enter Employee Name", "");
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

            var _temp = [];
            _temp.push(serverCall('ManageApprovalStore.aspx/bindaction', { typeToBind: typeToBind }, function (response) {
                jQuery.when.apply(null, _temp).done(function () {
                    var $ReqData = JSON.parse(response);
                    console.log($ReqData);
                    if ($ReqData.length == 0) {

                        toast("Error", "No Action Found", "");
                        return;
                    }
                    else {
                        var $mydata = [];
                        $mydata.push('<tr>');
                        for (var i = 0; i <= $ReqData.length - 1; i++) {
                            $mydata.push('<td>');
                            if ($('#ddlType').val() == 'PO') {
                                if ($ReqData[i].TypeIDApprove == "3") {
                                    $mydata.push('<input onclick="showpoapp(this)" id="chlApproval_'); $mydata.push($ReqData[i].TypeIDApprove); $mydata.push('"type="checkbox" value="');
                                    $mydata.push($ReqData[i].TypeIDApprove); $mydata.push('#'); $mydata.push($ReqData[i].typename);
                                    $mydata.push('"><label for="chlApproval_'); $mydata.push($ReqData[i].TypeIDApprove);
                                    $mydata.push('">'); $mydata.push($ReqData[i].typename); $mydata.push('</label>');
                                }
                                else {
                                    $mydata.push('<input id="chlApproval_'); $mydata.push($ReqData[i].TypeIDApprove); $mydata.push('"type="checkbox" value="');
                                    $mydata.push($ReqData[i].TypeIDApprove); $mydata.push('#'); $mydata.push($ReqData[i].typename);
                                    $mydata.push('"><label for="chlApproval_'); $mydata.push($ReqData[i].TypeIDApprove); $mydata.push('">');
                                    $mydata.push($ReqData[i].typename); $mydata.push('</label>');
                                }
                            }
                            else {
                                $mydata.push('<input id="chlApproval_'); $mydata.push($ReqData[i].TypeIDApprove); $mydata.push('" type="checkbox" value="');
                                $mydata.push($ReqData[i].TypeIDApprove); $mydata.push('#'); $mydata.push($ReqData[i].typename); $mydata.push('"><label for="chlApproval_');
                                $mydata.push($ReqData[i].TypeIDApprove); $mydata.push('">'); $mydata.push($ReqData[i].typename); $mydata.push('</label>');
                            }
                            $mydata.push('</td>');
                        }
                        $mydata.push("</tr>");

                        $mydata = $mydata.join("");
                        jQuery('#chlApproval').append($mydata);

                    }
                });
            }));

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
                toast("Error", "Please Enter Employee Name", "");
                jQuery("#txtEmployee").focus();
                return;
            }
            if (jQuery("#ddlType").val() == "0") {

                toast("Error", "Please Select Authority Type", "");
                jQuery("#ddlType").focus();
                return;
            }
            var typeData = '';
            $("[id*=chlApproval] input:checked").each(function () {
                typeData += $(this).val() + ",";
            });

            if (typeData == '') {
                toast("Error", "Please Select Approval...!", "");
                return false;
            }

            if (jQuery("#ddlType").val() == "PO" && typeData.indexOf('3') != -1 && $('#txtpolimitperpo').val() == "") {
                toast("Error", "Please Enter  Maxmimum Limit (Per PO) For Approval...!", "");
                $('#txtpolimitperpo').focus();
                return false;
            }
            if (jQuery("#ddlType").val() == "PO" && typeData.indexOf('3') != -1 && $('#txtpolimitpermonth').val() == "") {
                toast("Error", "Please Enter  Maxmimum Limit (Per Month) For Approval...!", "");
                $('#txtpolimitpermonth').focus();
                return false;
            }

            serverCall('ManageApprovalStore.aspx/SaveApprovalRight', { EmployeeID: jQuery("#hdEmployeeID").val(), typeData: typeData, appRightFor: jQuery("#ddlType").val(), ShowRate: jQuery("#rblShowRate input[type=radio]:checked").val(), POAppLimitPerPO: $('#txtpolimitperpo').val(), POAppLimitPerMonth: $('#txtpolimitpermonth').val() }, function (response) {
                var result = response;
                if (result == "success") {
                    toast("Success", "Record Saved Successfully", "");

                    searchApproval('0');
                }
                else {
                    jQuery('#spnError').text(result);
                }
            });


        }
        function onSucessApproval(result) {
            if (result == "success") {
                toast("Success", "Record Saved Successfully", "");
                searchApproval('0');

            }
            else {
                toast("Error", result, "");

            }

        }
        function onFailureApproval(result) {

        }

        function searchApproval(con) {
            jQuery('#spnError').text('');
            showHideRate();
            $('#trpoapproval').hide();
            $('#txtpolimitperpo').val('');
            $('#txtpolimitpermonth').val('');
            if (con == "0" && jQuery("#ddlType").val() == 0) {
                jQuery('#div_Approval').html('');
                return;
            }

            if (con == "1") {
                var _temp = [];
                _temp.push(serverCall('ManageApprovalStore.aspx/bindManageApproval', { appRightFor: 0, Con: con }, function (response) {
                    jQuery.when.apply(null, _temp).done(function () {
                        ApprovalData = JSON.parse(response);
                        var output = jQuery('#sc_Approval').parseTemplate(ApprovalData);
                        jQuery('#div_Approval').html(output);

                    });
                }));
            }
            else if (jQuery("#ddlType").val() != 0 && con == "0") {
                searchApproval();
                bindApprovalData(jQuery("#ddlType").val());

                var _temp = [];
                _temp.push(serverCall('ManageApprovalStore.aspx/bindManageApproval', { appRightFor: jQuery("#ddlType").val(), Con: con }, function (response) {
                    jQuery.when.apply(null, _temp).done(function () {
                        ApprovalData = JSON.parse(response);
                        var output = jQuery('#sc_Approval').parseTemplate(ApprovalData);
                        jQuery('#div_Approval').html(output);

                    });
                }));
            }
            else {
                $('#chlApproval tr').remove();
                jQuery('#div_Approval').html('');
            }
        }

        function AddMorePO() {
            if (jQuery("#ddlType").val() == 'PO') {
                $("[id*=chlApproval] input").each(function () {
                    $(this).prop('disabled', false);
                });
            }
            else {
                $("[id*=chlApproval] input").each(function () {
                    if ($(this).val().split('#')[0] == '4' || $(this).val().split('#')[0] == '5' || $(this).val().split('#')[0] == '6') {
                        $(this).prop('disabled', true);
                    }
                    else {
                        $(this).prop('disabled', false);
                    }
                });
            }
        }
        function showHideRate() {
            if (jQuery("#ddlType").val() == "PI" || jQuery("#ddlType").val() == "SI") {
                jQuery("#trShowRate").show();
                jQuery("#rblShowRate  input[value=1]").prop("checked", "checked");
            }
            else {

                jQuery("#rblShowRate  input[value=1]").prop("checked", "checked");
                jQuery("#trShowRate").hide();
            }

        }

        jQuery(function () {
            jQuery("#<%=txtEmployee.ClientID%>").autocomplete({
                autoFocus: true,
                source: function (request, response) {
                    var _temp = [];
                    _temp.push(serverCall('ManageApprovalStore.aspx/SearchEmployee', { query: jQuery("#<%=txtEmployee.ClientID%>").val() }, function (responsenew) {
                        jQuery.when.apply(null, _temp).done(function () {
                            var result = JSON.parse(responsenew);
                            response(result);
                        });
                    }));
                },
                focus: function () {

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
             <td class="GridViewHeaderStyle" style=" text-align: left">Employee Code</td>
            <td class="GridViewHeaderStyle" style="text-align: left">Authority Type</td>
            <td class="GridViewHeaderStyle" style="text-align: left">Approval</td>
            <td class="GridViewHeaderStyle" style="text-align: left">PO Approval<br /> Limit(Per PO)</td>
            <td class="GridViewHeaderStyle" style="text-align: left">PO Approval<br /> Limit(Per Month)</td>
             <td class="GridViewHeaderStyle" style="text-align: left">PO Sign</td>
            <td class="GridViewHeaderStyle" style="text-align: left">ShowRate</td>
           
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
                <td  class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.EmployeeCode#></td>
            <td  class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.TypeName#></td>
            <td  class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.AppRightFor#></td>  
               
                <td  class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.POAppLimitPerPO#></td>
                <td  class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.POAppLimitPerMonth#></td> 
                <# if(objRow.TypeName=='Approval' && objRow.AppRightFor=='PO')
                { #>
                <td  class="GridViewLabItemStyle" style="text-align:left;">

                     <a style="font-weight:bold;" target="_blank" href="<#=objRow.posign#>">View Sign</a>

                </td> 
                <#}
                else
                {
                #>
                <td  class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.POAppLimitPerMonth#></td> 
                <#}#>
                <td  class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.rateshow#></td>        
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
                serverCall('ManageApprovalStore.aspx/removeManageApproval', { AppRightID: ApprightID }, function (response) {
                    var result = response;
                    if (result == "1") {
                        searchApproval('0');
                        toast("Success", "Record Updated Successfully", "");

                    }
                    else {
                        toast("Error", 'Record Not Saved', "");

                    }

                });

            }
            function clearAction() {

            }
            function exportReport() {
                serverCall('ManageApprovalStore.aspx/exportToExcel', {}, function (response) {
                    var result = response;
                    if (result == "0") {
                        toast("Error", 'Record Not Saved', "");

                    }
                    else if (result == "1") {
                        window.open('../common/ExportToExcel.aspx');

                    }

                });
            }

     </script>
</asp:Content>

