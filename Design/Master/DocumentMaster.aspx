<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="DocumentMaster.aspx.cs" Inherits="Design_Master_DocumentMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="asp" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
        <webopt:BundleReference ID="BundleReference7" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
     <%: Scripts.Render("~/bundles/confirmMinJS") %>
      <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox.pack.js"></script>
    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />

    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <div id="Pbody_box_inventory">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-24">
                    <b>Document Master<br />
                    </b>                    
                </div>
            </div>

        </div>

        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-4">
                    <label class="pull-left">Document Name </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtDocName" CssClass="requiredField" MaxLength="50" runat="server"></asp:TextBox>
                    <input type="hidden" value="" id="hfDocID" />
                </div>
                <div class="col-md-4">
                    <label class="pull-left">Document No. </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtDocNo" MaxLength="50" CssClass="requiredField" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">Document Date </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtDocumentDate" CssClass="requiredField" runat="server"></asp:TextBox>
                    <cc1:CalendarExtender ID="calDocument" runat="server" TargetControlID="txtDocumentDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
            </div>
            <div class="row">
                <div class="col-md-4">
                    <label class="pull-left">Last Amendmend Date </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtAmendDate" runat="server"></asp:TextBox>
                    <cc1:CalendarExtender ID="calAmendDate" runat="server" TargetControlID="txtAmendDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">Last Amendmend Reason </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtAmendmendReason" MaxLength="50" runat="server"></asp:TextBox>
                </div>
                <div class="col-md-4">
                    <label class="pull-left">Department</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:ListBox ID="lstdepartment" runat="server" Width="151px" ClientIDMode="Static" CssClass="multiselect requiredField" SelectionMode="Multiple"></asp:ListBox>
                    <img alt="addMore" src="../../App_Images/ButtonAdd.png" onclick="ShowpopUp()" style="cursor: pointer;" />
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <input type="button" id="btnSave" class="ItDoseButton" value="Save" onclick="$saveDetails();" />
            <input type="button" id="btnClear" class="ItDoseButton" value="Clear" onclick="$Clear();" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="Purchaseheader">
                Document Details
            </div>
            <div id="PatientLabSearchOutput" style="max-height: 350px; overflow: auto;">
            </div>
        </div>
    </div>
    <asp:Button ID="btnButton" runat="server" Style="display: none" OnClientClick="JavaScript: return false;" />
    <cc1:ModalPopupExtender ID="mpAddDept" runat="server"
        DropShadow="true" TargetControlID="btnButton" CancelControlID="btnClosepopUp" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlAddDept" BehaviorID="mpAddDept">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlAddDept" runat="server" Style="display: none; width: 380px; height: 120px;" CssClass="pnlVendorItemsFilter">      
        <div class="POuter_Box_Inventory" style="text-align: center; width: 99.6%;">
            <div class="row">
                <div class="col-md-24">
                    <b>Add Deprtmant<br />
                    </b>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="width: 99.6%; height: 76.5%;">
            <div class="row">
                <div class="col-md-12">
                    <label class="pull-left">Department Name</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-12">
                    <asp:TextBox ID="txtDept" CssClass="requiredField" runat="server"></asp:TextBox>
                    <input type="hidden" value="" id="hfDeptID" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-4">
                </div>
            </div>
            <div class="row">
                <div class="col-md-4">
                </div>
            </div>
            <div class="row">
                <div class="col-md-4">
                </div>
            </div>
            <div class="row">
                <div class="col-md-4">
                </div>
            </div>

            <div class="row">
                <div class="col-md-4">
                </div>
                <div class="col-md-13" style="text-align: center">
                    <input type="button" id="btnsaveDept" class="ItDoseButton" value="Save" onclick="$saveNewDept();" />
                    <input type="button" id="btnClosepopUp" class="ItDoseButton" value="Close" />
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center; width: 99.6%; display:none";>
            <div id="divDeptList" style="max-height: 350px; overflow: auto;">
            </div>
        </div>          
    </asp:Panel>


    
    <asp:Button ID="Button1" runat="server" Style="display: none" OnClientClick="JavaScript: return false;" />
    <cc1:ModalPopupExtender ID="mpUploadImage" runat="server"
        DropShadow="true" TargetControlID="Button1" CancelControlID="btnCloseImage" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlUploadImage" BehaviorID="mpUploadImage">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlUploadImage" runat="server" Style="display: none; width: 556px; height: 160px;" CssClass="pnlVendorItemsFilter">
        <div class="POuter_Box_Inventory" style="text-align: center; width: 99.6%;">
            <div class="row">
                <div class="col-md-24">
                    <b>Upload Dynamic Header<br />
                    </b>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="width: 99.6%; height: 58.5%;">
            <div class="row">
                <div class="col-md-12">
                    <input type="file" accept="image/*" id="FileUploadDynamicHeader" />

                </div>
            </div>
            <div class="row">
                <div class="col-md-4">
                </div>
            </div>
            <div class="row">
                <div class="col-md-4">
                </div>
            </div>
            <div class="row">
                <div class="col-md-4">
                </div>
            </div>
            <div class="row">
                <div class="col-md-4">
                </div>
            </div>

            <div class="row">
                <div class="col-md-4">
                </div>
                <div class="col-md-13" style="text-align: center">
                    <input type="button" id="btnSaveDynamicHeader" class="ItDoseButton" value="Save" onclick="uploadFile('DynamicHeader');" />
                    <input type="button" id="btnCloseImage" class="ItDoseButton" value="Close" />
                </div>
            </div>

        </div>
        <div class="POuter_Box_Inventory" style="text-align: center; width: 99.6%">
            <div id="divImageList" style="max-height: 350px; overflow: auto;">
            </div>
        </div>

    </asp:Panel>
    



      
    <asp:Button ID="Button2" runat="server" Style="display: none" OnClientClick="JavaScript: return false;" />
    <cc1:ModalPopupExtender ID="mpUploadDocument" runat="server"
        DropShadow="true" TargetControlID="Button2" CancelControlID="btnClosePDF" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlUploadPDF" BehaviorID="mpUploadDocument">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlUploadPDF" runat="server" Style="display: none; width: 556px; height: 160px;" CssClass="pnlVendorItemsFilter">
        <div class="POuter_Box_Inventory" style="text-align: center; width: 99.6%;">
            <div class="row">
                <div class="col-md-24">
                    <b>Upload Document<br />
                    </b>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="width: 99.6%; height: 58.5%;">
            <div class="row">
                <div class="col-md-12">
                    <input type="file" accept="application/pdf,image/*" id="FileUploadPDF" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-4">
                </div>
            </div>
            <div class="row">
                <div class="col-md-4">
                </div>
            </div>
            <div class="row">
                <div class="col-md-4">
                </div>
            </div>
            <div class="row">
                <div class="col-md-4">
                </div>
            </div>

            <div class="row">
                <div class="col-md-4">
                </div>
                <div class="col-md-13" style="text-align: center">
                    <input type="button" id="btnSavePDF" class="ItDoseButton" value="Save" onclick="uploadPDF('ClientDocument');" />
                    <input type="button" id="btnClosePDF" class="ItDoseButton" value="Close" />
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center; width: 99.6%">
            <div id="divPDFList" style="max-height: 350px; overflow: auto;">
            </div>
        </div>
    </asp:Panel>
    
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
            $("#btnSave").val('Save');
            $('[id*=lstdepartment]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $bindAllDepartMent(function () { });
            $SearchDetails(function () { });
        });

        $bindAllDepartMent = function () {
            jQuery('#lstdepartment option').remove();
            $lstdepartment = $('#lstdepartment');
            serverCall('DocumentMaster.aspx/getDepartment', {}, function (response) {
                Data = JSON.parse(response);

                if (Data != null) {
                    for (var i = 0; i < Data.length; i++) {
                        $lstdepartment.append(jQuery("<option></option>").val(Data[i].ID).html(Data[i].DepartmentName));
                    }
                }
                $lstdepartment.multipleSelect("refresh");

            });
        }
        function ShowpopUp() {
            $("#<%=txtDept.ClientID%>").val('');
            FetchDept();
            $find("mpAddDept").show();
        }

        var $Clear = function () {

            $("#hfDocID").val('');
            $("#<%=txtDocName.ClientID%>,#<%=txtDocNo.ClientID%>,#<%=txtAmendDate.ClientID%>,#<%=txtAmendmendReason.ClientID%>").val('');
            
            jQuery('#lstdepartment').val('');
            jQuery('#lstdepartment').multipleSelect("refresh");
            $("#btnSave").val('Save');
        }



        var $saveNewDept = function () {
            if ($("#<%=txtDept.ClientID%>").val() == "") {
                toast("Error", "Please Enter Department Name", "");
                $("#<%=txtDept.ClientID%>").focus();
                return false;
            }
            $("#btnsaveDept").val("Please wait...");
            $("#btnsaveDept").prop("disabled", true);
            serverCall('DocumentMaster.aspx/SaveDepartment', { deptID: $("#hfDeptID").val(), deptName: $("#<%=txtDept.ClientID%>").val() }, function (response) {

                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast("Success", "Record Saved Successfully", "");
                    $find("mpAddDept").hide();
                    //FetchDept();
                    $bindAllDepartMent(function (response) { });

                }
                else {
                    toast("Error", $responseData.ErrorMsg, "");
                }

                $("#btnsaveDept").val("Save");
                $("#btnsaveDept").prop("disabled", false);
                $modelUnBlockUI(function () { });

            });

        }

        function Validate() {
            if ($("#<%=txtDocName.ClientID%>").val() == "") {
                toast("Error", "Please fill Document Name", "");
                return false;
            }
            if ($("#<%=txtDocNo.ClientID%>").val() == "") {
                toast("Error", "Please fill Document no", "");
                return false;
            }
            if ($("#<%=txtDocumentDate.ClientID%>").val() == "") {
                toast("Error", "Please fill Document Date", "");
                return false;
            }

            if ($('#lstdepartment').val() == "") {
                toast("Error", "Please select Department", "");
                return false;
            }
            return true;
        }

        var $saveDetails = function () {
            if (!Validate()) {
                return false;
            }
            var _DocDetails = DocumentData();
            serverCall('DocumentMaster.aspx/SaveDocDetails', { DocDetails: _DocDetails }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast("Success", $responseData.response, "");
                    $SearchDetails(function () { });
                    $Clear();
                    DocID = $responseData.data;
                    if ($responseData.data > 0)
                        $find("mpUploadDocument").show();
                    $("#btnSavePDF").val("Save");
                    $("#btnSavePDF").prop("disabled", false);
                    $('#FileUploadPDF').val('');
                }
                else {
                    toast("Error", $responseData.response, "");
                }
                $modelUnBlockUI(function () { });
            });

        }

        var $SearchDetails = function () {
            serverCall('DocumentMaster.aspx/GetDocDetails', { DocName: "", DocNo: "", DeptIds: "" }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    PatientData = $responseData.data;
                    var mydata = [];
                    mydata.push('<tr>');
                    mydata.push('<tr id="Header">');
                    mydata.push('<th class="GridViewHeaderStyle" scope="col" style="width:45px;">S.No.</th>');
                    mydata.push('<th class="GridViewHeaderStyle" scope="col" style="width:137px;">Document Name</th>');
                    mydata.push('<th class="GridViewHeaderStyle" scope="col" style="width:135px;">Document No.</th>');
                    mydata.push('<th class="GridViewHeaderStyle" scope="col" style="width:120px;">Document Date</th>');
                    mydata.push('<th class="GridViewHeaderStyle" scope="col" style="width:155px;">Last Amendmend Date</th>');
                    mydata.push('<th class="GridViewHeaderStyle" scope="col" style="width:181px;">Last Amendmend Reason</th>');
                    mydata.push('<th class="GridViewHeaderStyle" scope="col" style="width:168px;">Department(s)</th>');
                    mydata.push('<th class="GridViewHeaderStyle" scope="col" style="width:166px;">Entry by</th>');
                    mydata.push('<th class="GridViewHeaderStyle" scope="col" style="width:111px;">Entry Date</th>');
                    mydata.push('<th class="GridViewHeaderStyle" scope="col" style="width:10px;">Edit</th>');
                    mydata.push('<th class="GridViewHeaderStyle" scope="col" style="width:10px;">Show Doc</th>');
                    mydata.push('<th class="GridViewHeaderStyle" scope="col" style="width:10px;">Upload Doc</th>');
                    mydata.push('<th class="GridViewHeaderStyle" scope="col" style="width:10px;">Doc Access</th>');
                    mydata.push('</tr>');
                    var TotalBilledAmount = 0;
                    var TotalPaidAmountAmount = 0;
                    for (var j = 0; j < PatientData.length; j++) {
                        var output = [];
                        output.push('<tr id="tr_');
                        output.push((parseInt(j) + 1));
                        output.push('">');
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
                        output.push('<td id="tdDocName"  class="GridViewLabItemStyle"  style="text-align:left">');
                        output.push(PatientData[j].docName); output.push('</td>');
                        output.push('<td id="tdDocNo" class="GridViewLabItemStyle"  style="text-align:left">');
                        output.push(PatientData[j].docNo); output.push('</td>');
                        output.push('<td id="tdDocDate" class="GridViewLabItemStyle" >');
                        output.push(PatientData[j].docDate); output.push('</td>');
                        output.push('<td id="tdAmDate" class="GridViewLabItemStyle"  >');
                        output.push(PatientData[j].lastAmendmendDate); output.push('</td>');
                        output.push('<td  id="tdAmReason" class="GridViewLabItemStyle" style="text-align:left">');
                        output.push(PatientData[j].lastAmendmendReason); output.push('</td>');
                        output.push('<td  id="tdDeptName" class="GridViewLabItemStyle" style="text-align:left">');
                        output.push(PatientData[j].depatrmentNames); output.push('</td>');
                        output.push('<td  id="tdEntryBy" class="GridViewLabItemStyle" style="text-align:left">');
                        output.push(PatientData[j].EntryByName); output.push('</td>');
                        output.push('<td  id="tdEntryDate" class="GridViewLabItemStyle" >');
                        output.push(PatientData[j].EntryDate); output.push('</td>');
                        output.push('<td class="GridViewLabItemStyle"  Style=" text-align:center" ><img style="cursor: pointer;vertical-align: middle;" alt="edit" src="../../App_Images/edit.png" onclick="EditDetails(this)" /> </td>');
                        if (PatientData[j].docPath == "") {
                            output.push('<td class="GridViewLabItemStyle"  Style=" text-align:center" > </td>');

                        }
                        else {
                            output.push('<td class="GridViewLabItemStyle"  Style= "text-align:center;background: #3cca39;vertical-align: middle;" ><img style="cursor: pointer;" alt="Show" src="../../App_Images/view.GIF" onclick="showDocs(this)" /> </td>');

                        }
                        output.push('<td id="chkbox"class="GridViewLabItemStyle"><img style="cursor: pointer;vertical-align: middle;" alt="Access" src="../../App_Images/attachment.png" onclick="ShowImagePopUp(1,this)" /> </td>');

                        output.push('<td id="chkbox"class="GridViewLabItemStyle"><img style="cursor: pointer;width: 18px;vertical-align: middle;" alt="upload pdf" src="../../App_Images/report_check.png"  onclick="openAccess(this)"   /> </td>');
                        output.push('</tr>');
                        output = output.join('');
                        mydata.push(output);
                    }

                    $('#PatientLabSearchOutput').html(mydata);
                }
                else {
                    toast("Error", $responseData.data, "");
                }
                $modelUnBlockUI(function () { });

            });
        }
        function showDocs(ctr) {
            var DocFileName = $(ctr).closest('tr').find('#hdndocPath').val();

            var extension = DocFileName.substr((DocFileName.lastIndexOf('.') + 1));
            


            
            $("#imagePreview").empty();
            serverCall('DocumentMaster.aspx/getDocumentView', { ID: $(ctr).closest('tr').find('#hdnId').val() }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    if ($responseData.response != "") {
                        var $img = "";
                        if (extension == 'jpeg' || extension == 'jpg' || extension == 'png') {                           
                            $img = $("<img id='imgImage'/>");
                            $img.attr("src", "data:image/png;base64," + $responseData.response);                         
                        }
                        else
                        {
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

        function DocumentData() {
            var objDoc = new Object();
            objDoc.ID = $("#hfDocID").val();
            objDoc.DocName = $("#<%=txtDocName.ClientID%>").val();
            objDoc.DocNo = $("#<%=txtDocNo.ClientID%>").val();;
            objDoc.DocPDFPath = "";
            objDoc.docDate = $("#<%=txtDocumentDate.ClientID%>").val();
            objDoc.DocDynamicImage = "";
            objDoc.LastAmenmendDate = $("#<%=txtAmendDate.ClientID%>").val();
            objDoc.LastAmenmendReason = $("#<%=txtAmendmendReason.ClientID%>").val();
            objDoc.DeptIds = jQuery.trim(jQuery("#lstdepartment").val());
            var Names = new Array();
            $("#lstdepartment  option:selected").each(function () {

                Names.push($(this).text());

            });
            objDoc.DeptNames = jQuery.trim(Names);
            return objDoc;
        }


        function EditDetails(ctr) {
            var $row = $(ctr).closest('tr');
            $("#hfDocID").val($row.find("#hdnId").val())
            $("#<%=txtDocName.ClientID%>").val($row.find("#tdDocName").html());
            $("#<%=txtDocNo.ClientID%>").val($row.find("#tdDocNo").html());
            $("#<%=txtDocumentDate.ClientID%>").val($row.find("#tdDocDate").html());
            $("#<%=txtAmendDate.ClientID%>").val($row.find("#tdAmDate").html());
            $("#<%=txtAmendmendReason.ClientID%>").val($row.find("#tdAmReason").html());
            $("#<%=lstdepartment.ClientID%>").val($row.find("#hdnIdIds").val().split(','));
            $("#<%=lstdepartment.ClientID%>").multipleSelect("refresh");
            $("#btnSave").val('Update');
        }

        var DocID = "";
        function ShowImagePopUp(type, ctr) {
            var $row = $(ctr).closest('tr');
            DocID = $row.find("#hdnId").val();
            if (type == "2") {
                FetchDynamicImage(DocID, "DynamicHeader");
                $find("mpUploadImage").show();
                $("#btnSaveDynamicHeader").val("Save");
                $("#btnSaveDynamicHeader").prop("disabled", false);
                $('#FileUploadDynamicHeader').val('');

            }
            else {
                FetchPDF(DocID, "Document");
                $find("mpUploadDocument").show();
                $("#btnSavePDF").val("Save");
                $("#btnSavePDF").prop("disabled", false);
                $('#FileUploadPDF').val('');

            }
        }

        function FetchPDF(DocID, type) {
            serverCall('DocumentMaster.aspx/GetDocumentDetails', { DocID: DocID, type: type }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    PatientData = $responseData.data;
                    var mydata = [];
                    mydata.push('<tr>');
                    mydata.push('<tr id="Header">');
                    mydata.push('<th class="GridViewHeaderStyle" scope="col" style="width:37px;">S.No.</th>');
                    mydata.push('<th class="GridViewHeaderStyle" scope="col" style="width:276px;">Image</th>');
                    mydata.push('<th class="GridViewHeaderStyle" scope="col" style="width:145px;">Uploaded by</th>');
                    mydata.push('<th class="GridViewHeaderStyle" scope="col" style="width:88px;">Date</th>');
                    mydata.push('<th class="GridViewHeaderStyle" scope="col" style="width:88px;"> </th>');
                    mydata.push('</tr>');
                    for (var j = 0; j < PatientData.length; j++) {
                        var output = [];
                        output.push('<tr id="tr_');
                        output.push((parseInt(j) + 1));
                        output.push('">');
                        output.push('<td class="GridViewLabItemStyle">');
                        output.push((parseInt(j) + 1));
                        output.push('<input type="hidden" id="hfnDocID" value="');
                        output.push(PatientData[j].ID);
                        output.push('"/>');
                        output.push('<input type="hidden" id="hfDynamicImage" value="');
                        output.push(PatientData[j].dynamicImageHeaderPath);
                        output.push('"/>');
                        output.push('</td>');
                        output.push('<td id=""  class="GridViewLabItemStyle"  style="width:100px;">');
                        //    output.push('<a target="_blank" href="../../App_Images/' + type + '/');
                        //   output.push(PatientData[j].dynamicImageHeaderPath);
                        //    output.push(' ">');
                        output.push(PatientData[j].dynamicImageHeaderPath);
                        output.push('</a>');
                        output.push('</td>');
                        output.push('<td  id="tddynmicImageUploadName" class="GridViewLabItemStyle">');
                        output.push(PatientData[j].dynamicImageUploadName);
                        output.push('</td>');
                        output.push('<td  id="tddynamicImageUploadDate" class="GridViewLabItemStyle">');
                        output.push(PatientData[j].dynmicImageUploadDate);
                        output.push('</td>');
                        output.push('<td class="GridViewLabItemStyle"  Style="width:10px;"><img style="cursor: pointer;" alt="Delete" src="../../App_Images/Delete.gif" onclick="deleteDoc(this)" /> </td>');
                        output.push('</tr>');
                        output = output.join('');
                    }
                    mydata.push(output);

                    $('#divPDFList').html(mydata);
                }
                else {
                    $('#divPDFList').html('');
                    toast("Error", $responseData.data, "");
                }
                $modelUnBlockUI(function () { });
            });
        }
        function FetchDynamicImage(DocID) {
            serverCall('DocumentMaster.aspx/GetDocumentDetails', { DocID: DocID, type: 'dynamicImage' }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    PatientData = $responseData.data;
                    var mydata = [];
                    mydata.push('<tr>');
                    mydata.push('<tr id="Header">');
                    mydata.push('<th class="GridViewHeaderStyle" scope="col" style="width:37px;">S.No.</th>');
                    mydata.push('<th class="GridViewHeaderStyle" scope="col" style="width:276px;">Image</th>');
                    mydata.push('<th class="GridViewHeaderStyle" scope="col" style="width:145px;">Uploaded by</th>');
                    mydata.push('<th class="GridViewHeaderStyle" scope="col" style="width:88px;">Date</th>');
                    mydata.push('</tr>');
                    for (var j = 0; j < PatientData.length; j++) {
                        var output = [];
                        output.push('<tr id="tr_');
                        output.push((parseInt(j) + 1));
                        output.push('">');
                        output.push('<td class="GridViewLabItemStyle">');
                        output.push((parseInt(j) + 1));
                        output.push('</td>');
                        output.push('<td id="tdDynamicImage"  class="GridViewLabItemStyle"  style="width:100px;">');
                        //  output.push('<a target="_blank" href="../../App_Images/DynamicHeader/');
                        //   output.push(PatientData[j].dynamicImageHeaderPath);
                        // output.push(' ">');
                        output.push(PatientData[j].dynamicImageHeaderPath);
                        // output.push('</a>');
                        output.push('</td>');
                        output.push('<td  id="tddynmicImageUploadDate" class="GridViewLabItemStyle">');
                        output.push(PatientData[j].dynamicImageUploadName);
                        output.push('</td>');
                        output.push('<td  id="tddynamicImageUploadName" class="GridViewLabItemStyle">');
                        output.push(PatientData[j].dynmicImageUploadDate);
                        output.push('</td>');
                        output.push('</tr>');
                        output = output.join('');
                    }
                    mydata.push(output);

                    $('#divImageList').html(mydata);
                }
                else {
                    $('#divImageList').html('');
                    toast("Error", $responseData.data, "");
                }
                $modelUnBlockUI(function () { });
            });
        }

        function uploadFile(_type) {
            if (DocID == "") {
                toast("Error", "Please Re-Open pop up", "");
                return false;
            }
            if ($('#FileUploadDynamicHeader')[0].files.length == 0) {
                toast("Error", "Please select image", "");
                return false;
            }
            var _data = new FormData();
            _data.append('file', $('#FileUploadDynamicHeader')[0].files[0]);

            $("#btnSaveDynamicHeader").val("Uploading....");
            $("#btnSaveDynamicHeader").prop("disabled", true);
            $.ajax({
                type: 'post',
                url: String.format('UploadDocumentHandler.ashx/?id={0}&type={1}', DocID, _type),
                data: _data,
                success: function (status) {
                    if (status == "1") {
                        FetchDynamicImage(DocID);
                        toast("Success", "Attechment Saved Successfully", "");
                        $('#FileUploadDynamicHeader').val('');
                    }
                    else {
                        toast("Error", "There are some techincal error", "");

                    }
                    $("#btnSaveDynamicHeader").val("Save");
                    $("#btnSaveDynamicHeader").prop("disabled", false);

                    $modelUnBlockUI(function () { });
                },
                processData: false,
                contentType: false,
                error: function () {
                    toast("Error", "There are some techincal error", "");
                }
            });
        }


        function uploadPDF(_type) {
            if (DocID == "") {
                toast("Error", "Please Re-Open pop up", "");
                return false;
            }
            if ($('#FileUploadPDF')[0].files.length == 0) {
                toast("Error", "Please select Document", "");
                return false;
            }
            var _data = new FormData();
            _data.append('file', $('#FileUploadPDF')[0].files[0]);

            $("#btnSavePDF").val("Uploading....");
            $("#btnSavePDF").prop("disabled", true);
            $.ajax({
                type: 'post',
                url: String.format('UploadDocumentHandler.ashx/?id={0}&type={1}', DocID, _type),
                data: _data,
                success: function (status) {
                    if (status == "1") {
                        FetchPDF(DocID, "Document");
                        toast("Success", "Attechment Saved Successfully", "");
                        $('#FileUploadPDF').val('');
                        $SearchDetails(function () { });
                    }
                    else {
                        toast("Error", "There are some techincal error", "");

                    }
                    $("#btnSavePDF").val("Save");
                    $("#btnSavePDF").prop("disabled", false);

                    $modelUnBlockUI(function () { });
                },
                processData: false,
                contentType: false,
                error: function () {
                    toast("Error", "There are some techincal error", "");
                }
            });
        }

        function FetchDept() {
            serverCall('DocumentMaster.aspx/getDepartmentList', {}, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    PatientData = $responseData.data;
                    var mydata = [];
                    mydata.push('<tr>');
                    mydata.push('<tr id="Header">');
                    mydata.push('<th class="GridViewHeaderStyle" scope="col" style="width:37px;">S.No.</th>');
                    mydata.push('<th class="GridViewHeaderStyle" scope="col" style="width:276px;">Department</th>');
                    mydata.push('<th class="GridViewHeaderStyle" scope="col" style="width:145px;">Edit</th>');
                    mydata.push('</tr>');
                    for (var j = 0; j < PatientData.length; j++) {
                        var output = [];
                        output.push('<tr id="tr_');
                        output.push((parseInt(j) + 1));
                        output.push('">');
                        output.push('<td class="GridViewLabItemStyle">');
                        output.push((parseInt(j) + 1));
                        output.push('<input type="hidden" id="hfnDeptID" value="');
                        output.push(PatientData[j].ID);
                        output.push('"/>');
                        output.push('</td>');
                        output.push('<td  id="tdDepartmentName" class="GridViewLabItemStyle">');
                        output.push(PatientData[j].DepartmentName);
                        output.push('</td>');
                        output.push('<td class="GridViewLabItemStyle"  Style="width:50px; text-align:center" ><img style="cursor: pointer;" alt="edit" src="../../App_Images/edit.png" onclick="EditDept(this)" /> </td>');
                        output.push('</tr>');
                        output = output.join('');
                        mydata.push(output);
                    }


                    $('#divDeptList').html(mydata);
                }
                else {
                    $('#divDeptList').html('');
                    toast("Error", $responseData.data, "");
                }
                $modelUnBlockUI(function () { });
            });
        }


        function EditDept(ctr) {
            var $row = $(ctr).closest('tr');
            $("#hfDeptID").val($row.find("#hfnDeptID").val())
            $("#<%=txtDept.ClientID%>").val($row.find("#tdDepartmentName").html());
            $("#btnsaveDept").val('Update');
        }

        $("#FileUploadDynamicHeader").change(function () {
            var fileExtension = ['jpeg', 'jpg', 'png', 'gif', 'bmp'];
            if ($.inArray($(this).val().split('.').pop().toLowerCase(), fileExtension) == -1) {
                toast("Error", "Only formats are allowed : " + fileExtension.join(', '), "");
                $(this).val('');
            }
        });

        $("#FileUploadPDF").change(function () {
            var fileExtension = ['pdf', 'jpeg', 'jpg', 'png'];
            if ($.inArray($(this).val().split('.').pop().toLowerCase(), fileExtension) == -1) {
                toast("Error", "Only formats are allowed : " + fileExtension.join(', '), "");
                $(this).val('');
            }
        });

        function deleteDoc(ctr) {
            var $row = $(ctr).closest('tr');
            var DocID = $(ctr).closest('tr').find("#hfnDocID").val();
            var DocPath = $(ctr).closest('tr').find("#hfDynamicImage").val();


            $confirmationBox('Do You Want to Remove Document', DocID, DocPath);

            

        }
        $confirmationBox = function (contentMsg, DocID, DocPath) {
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
                            serverCall('DocumentMaster.aspx/deleteDoc', { DocID: DocID, DocPath: DocPath }, function (response) {
                                var $responseData = JSON.parse(response);
                                if ($responseData.status) {
                                    toast("Success", "Document Deleted Successfully", "");
                                    FetchPDF(DocID, "Document");
                                    $SearchDetails(function () { });
                                }
                                else {
                                    toast("Error", $responseData.ErrorMsg, "");
                                }
                                $modelUnBlockUI(function () { });

                            });
                        }
                    },
                    somethingElse: {
                        text: 'No',
                        action: function () {
                            $clearAction();
                        }
                    },
                }
            });
        }
        function $clearAction() {

        }
        function openAccess(ctr) {
            var DocID = $(ctr).closest('tr').find("#hdnId").val();
            openmypopup("DocumentMaster_access.aspx?DocID=" + DocID);
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
       $("#<%=txtDocName.ClientID%>,#<%=txtDept.ClientID%>").alphanum({
            allow: '.',
            disallow:'0123456789'
        });
       $("#<%=txtDocNo.ClientID%>,#<%=txtAmendmendReason.ClientID%>").alphanum({
            allow: '.'
         
        });
    </script>


</asp:Content>

