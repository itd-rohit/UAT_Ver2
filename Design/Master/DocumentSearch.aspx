<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="DocumentSearch.aspx.cs" Inherits="Design_Master_DocumentSearch" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="asp" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>



<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <webopt:BundleReference ID="BundleReference7" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    
    <%: Scripts.Render("~/bundles/ResultEntry") %>
    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link  href="../../App_Style/multiple-select.css" rel="stylesheet" />

    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>

    <div id="Pbody_box_inventory">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-24">
                    <b>Document Search<br />
                    </b>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Document Name</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtDocName" CssClass="" runat="server"></asp:TextBox>
                    <input type="hidden" value="" id="hfDocID" />
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Document No. </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtDocNo" CssClass="" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-4">
                    <input type="button" id="btnSave" class="ItDoseButton" value="Search" onclick="$SearchDetails();" />
                    <input type="button" id="btnClear" class="ItDoseButton" value="Clear" onclick="$Clear();" />
                </div>
                <div class="col-md-4" style="display: none">
                    <label class="pull-left">Department</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4" style="display: none">
                    <asp:ListBox ID="lstdepartment" Visible="false" runat="server" Width="151px" ClientIDMode="Static" CssClass="multiselect requiredField" SelectionMode="Multiple"></asp:ListBox>
                </div>
                 <div class="col-md-1 square badge-Printed"  style="height: 20px; width: 2%; float: left; cursor: pointer">
                </div>
                <div class="col-md-2">
                    Read
                </div>
                <div class="col-md-1 square badge-Approved "  style="height: 20px; width: 2%; float: left; cursor: pointer">
                </div>
                <div class="col-md-2" >
                    UnRead
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Document List
            </div>
            <div class="row">
            <div id="PatientLabSearchOutput" style="max-height: 350px; overflow: auto;width:100%">

                <div class="col-md-24">
                        <table id="tblDocument" style="border-collapse: collapse; width: 100%;">
                            <thead>
                                <tr id="Header">
                                    


                                    <td class="GridViewHeaderStyle" style="width: 20px;">S.No.</td>
                                    <td class="GridViewHeaderStyle" style="width: 137px;">Document Name</td>
                                    <td class="GridViewHeaderStyle" style="width: 135px;">Document No.</td>

                                    <td class="GridViewHeaderStyle" style="width: 120px;">Document Date</td>
                                    <td class="GridViewHeaderStyle" style="width: 155px;">Last Amendmend Date</td>
                                    <td class="GridViewHeaderStyle" style="width: 181px;">Last Amendmend Reason</td>
                                    <td class="GridViewHeaderStyle" style="width: 168px;">Department(s)</td>
                                    <td class="GridViewHeaderStyle" style="width: 166px;">Entry by</td>
                                    <td class="GridViewHeaderStyle" style="width: 111px;">Entry Date</td>
                                    <td class="GridViewHeaderStyle" style="width: 10px;">Show</td>
                                    
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>


            </div>
                </div>
        </div>
    </div>
               <div id="divShowDocument" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="min-width: 54%;max-width:54%">
			<div class="modal-header">
                 <div class="row">
                          <div class="col-md-12" style="text-align:left">
                              <h4 class="modal-title"></h4>
                              </div>
                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt;color: #0000ff;">
					Press esc or click<button type="button" class="closeModel"  onclick="$closeModel()" aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div>				
				<h4 class="modal-title"></h4>
			</div>
			<div class="modal-body">                                  
                     <div class="row">
                         <div class="col-md-24">                        
                        <div  id="imagePreview">                                                     
                          </div>                            
                          </div>
                  </div>               
                 </div>
            <div class="modal-footer">				
				<button type="button"  onclick="$closeModel()">Close</button>
			</div>

           
        </div>
         </div>
 </div>


    <script type="text/javascript">
        $closeModel = function () {
            $("#imagePreview").empty();
            $("#divShowDocument").hideModel();
        }
        $(function () {
            $('[id*=lstdepartment]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $bindAllDepartMent(function () { });
        });

        $bindAllDepartMent = function () {
            jQuery('#lstdepartment option').remove();
            $lstdepartment = $('#lstdepartment');
            serverCall('DocumentSearch.aspx/getDepartment', {}, function (response) {
                Data = JSON.parse(response);

                if (Data != null) {
                    for (var i = 0; i < Data.length; i++) {
                        $lstdepartment.append(jQuery("<option></option>").val(Data[i].ID).html(Data[i].DepartmentName));
                    }
                }
                $lstdepartment.multipleSelect("refresh");
            });
        }


        var $Clear = function () {
            $("#<%=txtDocName.ClientID%>").val('');
            $("#<%=txtDocNo.ClientID%>").val('');
            jQuery('#lstdepartment').val('');
            jQuery('#lstdepartment').multipleSelect("refresh");
            $("#PatientLabSearchOutput").html('');
        }
        var $SearchDetails = function () {
            $('#tblDocument tr').slice(1).remove();
            serverCall('DocumentSearch.aspx/GetDocDetails', { DocName: $("#<%=txtDocName.ClientID%>").val(), DocNo: $("#<%=txtDocNo.ClientID%>").val(), DeptIds: "" }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    PatientData = $responseData.data;
                   
                  
                  
                    for (var j = 0; j < PatientData.length; j++) {
                        var output = [];
                        output.push('<tr class="clickablerow" id="tr_');
                        output.push((parseInt(j) + 1));
                        output.push('" style="background-color:');
                        if (PatientData[j].IsRead != "0")
                            output.push(' aqua"');
                        else
                            output.push(' #90EE90"');
                        output.push('>');
                        output.push('<td class="GridViewLabItemStyle">');
                        output.push((parseInt(j) + 1));
                        output.push('<input type="hidden" id="hdnId" value="');
                        output.push(PatientData[j].ID);
                        output.push('"/>');
                        output.push('<input type="hidden" id="hdnIdIds" value="');
                        output.push(PatientData[j].depatrmentIDs);
                        output.push('"/>');
                        output.push('<input type="hidden" id="hdndocPath" value="');
                        output.push(PatientData[j].docPath);
                        output.push('"/>');
                        output.push('</td>');
                        output.push('<td id="tdDocName"  class="GridViewLabItemStyle"  style="width:100px;">');
                        output.push(PatientData[j].docName); output.push('</td>');
                        output.push('<td id="tdDocNo" class="GridViewLabItemStyle"  style="width:150px;">');
                        output.push(PatientData[j].docNo); output.push('</td>');
                        output.push('<td id="tdDocDate" class="GridViewLabItemStyle" Style="width:150px">');
                        output.push(PatientData[j].docDate); output.push('</td>');
                        output.push('<td id="tdAmDate" class="GridViewLabItemStyle" Style="width:50px;" >');
                        output.push(PatientData[j].lastAmendmendDate); output.push('</td>');
                        output.push('<td  id="tdAmReason" class="GridViewLabItemStyle" Style="width:50px;">');
                        output.push(PatientData[j].lastAmendmendReason); output.push('</td>');
                        output.push('<td  id="tdDeptName" class="GridViewLabItemStyle" Style="width:50px;">');
                        output.push(PatientData[j].depatrmentNames); output.push('</td>');
                        output.push('<td  id="tdEntryBy" class="GridViewLabItemStyle" Style="width:50px;">');
                        output.push(PatientData[j].EntryByName); output.push('</td>');
                        output.push('<td  id="tdEntryDate" class="GridViewLabItemStyle" Style="width:50px;">');
                        output.push(PatientData[j].EntryDate); output.push('</td>');
                        output.push('<td class="GridViewLabItemStyle"  Style= "width:50px;text-align:center;background: #3cca39;vertical-align: middle;" ><img style="cursor: pointer;" alt="Show" src="../../App_Images/view.GIF" onclick="showDocs(this)" /> </td>');
                        output.push('</tr>');
                        output = output.join('');
                        $('#tblDocument').append(output);
                    }

                    
                }
                else {
                    toast("Error", $responseData.data, "");
                }
                $modelUnBlockUI(function () { });

            });
        }
        function showDocs(ctr) {
            var $row = $(ctr).closest('tr');
            var DocFileName = $row.find('#hdndocPath').val();
            var DocID = $row.find("#hdnId").val();
            serverCall('DocumentSearch.aspx/DocumentReadLog', { DocID: DocID }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                   jQuery(ctr).closest("tr").css("background-color", "aqua");
                    


                    var extension = DocFileName.substr((DocFileName.lastIndexOf('.') + 1));
                    $("#imagePreview").empty();
                    serverCall('DocumentMaster.aspx/getDocumentView', { ID: DocID }, function (response) {
                        var $responseData = JSON.parse(response);
                        if ($responseData.status) {
                            if ($responseData.response != "") {
                                var $img = "";
                                if (extension == 'jpeg' || extension == 'jpg' || extension == 'png') {
                                    $img = $("<img id='imgImage'/>");
                                    $img.attr("src", "data:image/png;base64," + $responseData.response);
                                }
                                else {
                                    $img = $("<iframe id='iframePreview' height='100%' width='100%' frameborder='0' allowfullscreen style=' clip:rect(190px,1100px,800px,250px);top:-160px; left:-160px;'/>");
                                    $img.attr("src", "data:application/pdf;base64," + $responseData.response);
                                    $("#imagePreview").height('400px');
                                }
                                if ($img != "") {
                                    $("#imagePreview").append($img);
                                    $("#divShowDocument").showModel();
                                }
                            }
                        }
                    });
                }
                else {
                    toast("Error", $responseData.ErrorMsg, "");
                }
                $modelUnBlockUI(function () { });
             });

           
        }
        function openmypopup(href) {
            var width = '1120px';
            $.fancybox({
                maxWidth: 860,
                maxHeight: 800,
                fitToView: false,
                width: '110%',
                height: '90%',
                href: href,
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                'type': 'iframe'
            });
        }

    </script>


</asp:Content>

