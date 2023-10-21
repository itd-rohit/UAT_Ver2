<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Doctor_MIS.aspx.cs" Inherits="Design_DocAccount_Doctor_MIS" MasterPageFile="~/Design/DefaultHome.master" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
   <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
        <link href="../../App_Style/multiple-select.css" rel="stylesheet"/> 
    <%: System.Web.Optimization.Scripts.Render("~/bundles/MsAjaxJs") %>
     <%: Scripts.Render("~/bundles/JQueryUIJs") %>   
            <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <%: Scripts.Render("~/bundles/PostReportScript") %>
     <style type="text/css">        

         html > body thead.fixedHeader tr {
             display: block;
         }

         /* make the TH elements pretty */
         thead.fixedHeader th {
             background: #0880cf;
             font-weight: normal;
             padding: 4px 3px;
             text-align: center;
         }

         html > body tbody.scrollContent {
             display: block;
             height: 440px;
             overflow-y: auto;
             overflow-x: hidden;
         }

             tbody.scrollContent td, tbody.scrollContent tr.normalRow td {
                 border-bottom: none;
                 border-left: none;
                 padding: 4px 3px;
             }

             tbody.scrollContent tr.alternateRow td {
                 background: #EEE;
                 border-bottom: none;
                 border-left: none;
                 padding: 4px 3px;
             }

         html > body thead.fixedHeader th {
             width: 60px;
             max-width: 80px;
             min-width: 80px;
         }

         html > body tbody.scrollContent td {
             width: 60px;
             max-width: 80px;
             min-width: 80px;
         }
     </style>
<style type="text/css">
    .multiselect {
        width: 200px;
    }
</style>
   <style type="text/css">
       

        .ajax__calendar .ajax__calendar_container
        {
            z-index: 9999;
        }
    </style>
    <style>
        .column {
    float: left;
    width:69%;
   height:300px;  overflow: scroll;
}
.column1 {
    float: left;
    width:30%;
     height:300px;  overflow: scroll;
}
.column2{
    margin-top:5px;
    float: left;
    width:82%;
    
}
.column3{
    margin-top:5px;
    float: left;
    width:82%;
     height:170px;
}
.Subcolumn1{
    float: left;
    width:50%;
    
}
.column4{
 
    float: left;
   
    
}
/* Clear floats after the columns */
.row:after {
    content: "";
    display: table;
    clear: both;
}
.grid_scroll
{
    overflow: auto;
    height: 500px;
    border: solid 1px orange;
    height:200px;
    width: 800px;
}
.modal {
    display: none; /* Hidden by default */
    position: fixed; /* Stay in place */
    z-index: 1; /* Sit on top */
    padding-top: 100px; /* Location of the box */
    left: 0;
    top: 0;
    width: 100%; /* Full width */
    height: 100%; /* Full height */
    overflow: auto; /* Enable scroll if needed */
    background-color: rgb(0,0,0); /* Fallback color */
    background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
}
/* Modal Content */
.modal-content {
    background-color: #fefefe;
    margin: auto;
    padding: 20px;
    border: 1px solid #888;
    width:50%;
}
/* The Close Button */
.close {
    color: #aaaaaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
}
.close:hover,
.close:focus {
    color: #000;
    text-decoration: none;
    cursor: pointer;
}

    </style>
    <script type="text/javascript">
       
        $(function () {        
            $("#<%=ShowMorechk.ClientID%>").click(function () {
                var chkboxid=$("#<%=ShowMorechk.ClientID%>")
                if ($(this).is(':checked')) {
                    $("#tr1,#tr2").show();
                } else {
                    $("#tr1,#tr2").hide();
                }
            });   
            jQuery('[id*=ddlPanel],[id*=lstCentreAccess],[id*=lsDoctorSpl],[id*=ddlDoctor],[id*=ddlCategory],[id*=ddlDepartment],[id*=Area_text]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });     
        });
        function find_in_object(my_object, my_criteria) {
            return my_object.filter(function (obj) {
                return Object.keys(my_criteria).every(function (c) {
                    return obj[c] == my_criteria[c];
                });
            });

        }
        var PatientData = "";
        function SearchDoctorSummary() {
            //alert("its working");
            //  debugger;
            var EmpData = "";
            $('#div_testName,#div_patient').empty();
            try {
                $('#btnSave,#GrandTotal').hide();
                $('#div_Data').html('');
                var _CentreID = "";
                $('#<%=lstCentreAccess.ClientID%> :selected').each(function (i, selected) {
                    if (_CentreID == "") {
                        _CentreID = $(selected).val();
                    }
                    else {
                        _CentreID = _CentreID + "," + $(selected).val();
                    }
                });
                var _PanelID = "";
                $('#<%=ddlPanel.ClientID%> :selected').each(function (i, selected) {
                    if (_PanelID == "") {
                        _PanelID = $(selected).val();
                    }
                    else {
                        _PanelID = _PanelID + "," + $(selected).val();
                    }
                });
                var _ProID = "";

                var _DoctorID = "";
                $('#<%=ddlDoctor.ClientID%> :selected').each(function (i, selected) {
                    if (_DoctorID == "") {
                        _DoctorID = $(selected).val();
                    }
                    else {
                        _DoctorID = _DoctorID + "," + $(selected).val();
                    }
                });
                var _CategoryID = "";
                $('#<%=ddlCategory.ClientID%> :selected').each(function (i, selected) {
                    if (_CategoryID == "") {
                        _CategoryID = $(selected).val();
                    }
                    else {
                        _CategoryID = _CategoryID + "," + $(selected).val();
                    }
                });
                var _HeadDepartment = "";

                var _Department = "";
                $('#<%=ddlDepartment.ClientID%> :selected').each(function (i, selected) {
                    if (_Department == "") {
                        _Department = $(selected).val();
                    }
                    else {
                        _Department = _Department + "," + $(selected).val();
                    }
                });
                var _Area = "";
                $('#<%=Area_text.ClientID%> :selected').each(function (i, selected) {
                    if (_Area == "") {
                        _Area = $(selected).val();

                    }
                    else {

                        _Area = _Area + "," + $(selected).val();
                    }
                });
                var _Spclization = "";
                $('#<%=lsDoctorSpl.ClientID%> :selected').each(function (i, selected) {
                    if (_Spclization == "") {
                        _Spclization = $(selected).val();
                    }
                    else {
                        _Spclization = _Spclization + "," + $(selected).val();
                    }
                });

                var per1 = $("#<%=per1.ClientID%>").val();
                var val1 = $("#<%=val1.ClientID%>").val();
                var per2 = $("#<%=per2.ClientID%>").val();
                var val2 = $("#<%=val2.ClientID%>").val();
                var share1 = $("#<%=shareAmount1.ClientID%>").val();
                var share2 = $("#<%=shareAmount2.ClientID%>").val();
                var isReffDrop = $("#<%=IsReffDropdown.ClientID%>").val();
                var Doct_Mobile = $("#<%=Doc_phn.ClientID%>").val();
                $('#btnSearch').attr('disabled', true).val('Submitting...');
                serverCall('Doctor_MIS.aspx/SearchDoctorSummary', { dtFrom: $("#<%=dtFrom.ClientID %>").val(), dtTo: $("#<%=dtTo.ClientID %>").val(), CentreID: _CentreID, PanelID: _PanelID, ProID: _ProID, DoctorID: _DoctorID, CategoryID: _CategoryID, HeadDepartmentID: _HeadDepartment, DepartmentID: _Department, parm1: per1, val1: val1, parm2: per2, val2: val2, shareAmount1: share1, shareAmount2: share2, Area: _Area, Speclization: _Spclization, IsReff: isReffDrop, Doct_Mobile: Doct_Mobile }, function (response) {
                    if (response == "-1") {
                        toast("Info", "Session Expired,Please Login", "");
                        $('#btnSearch').attr('disabled', false).val('Search');
                        return;
                    }
                    else if (response == "0") {
                        toast("Info", "No Record Found..!", "");
                        $('#btnSearch').attr('disabled', false).val('Search');
                        return;
                    }
                    else {
					 
                        var doctID = "";
                        PatientData = jQuery.parseJSON(response);
                        var output = $('#tb_InvestigationItems').parseTemplate(PatientData);
                        $('#div_Data,#btnSave').show();
                        $('#div_Data').html(output);
                        $('#tb_Search').show();
                        $("#<%=ddlRefDoc.ClientID %> option").remove();
                            for (var i = 0; i < PatientData.length; i++) {
                                if (doctID == "") {
                                    doctID = PatientData[i].Doctor_ID;
                                }
                                else { doctID += "," + PatientData[i].Doctor_ID; }
                            }
                            $("#<%=Doct_ID_hiddn.ClientID%>").val(doctID);
                            $('#btnSearch').attr('disabled', false).val('Search');
                            $('#btnSave,#Doc_report,#Doc_Merge').show();
                    }                   
                });
            } catch (e) {
                $('#btnSearch').attr('disabled', false).val('Search');         
                toast("Error", e, "");
            }
        };

        function showdatafilter()
        {
            alert('fillter');
            var my_json = JSON.stringify(PatientData)            
            var phn = $("#<%=Doc_phn.ClientID%>").val();
            var Area=$("#<%=Area_text.ClientID%>").val();
            if (phn != '')
            {
                var filtered_json = find_in_object(JSON.parse(my_json), { Mobile: phn });
            }
            if (Area != '')
            {
                var filtered_json = find_in_object(JSON.parse(my_json), { A: phn });
            }
            console.log(filtered_json);
            PatientData = filtered_json;
            var output = $('#tb_InvestigationItems').parseTemplate(PatientData);
            $('#div_Data,#btnSave').show();
            $('#div_Data').html(output);            
        }   
 
    var EmpData = "";
    function ViewPatient(ID, tdid, MasterShare, Doct_Id, e) {              
        $("#<%=_valueMastershare.ClientID%>").val('');
        $("#<%=_Doct_IdHidn.ClientID%>").val(Doct_Id);
        var _mastershare = 0;
        if (MasterShare == "Y")
        { _mastershare = 1; }
        else { _mastershare = 0; }
        $("#<%=_valueMastershare.ClientID%>").val(_mastershare);
        //  var hidnid= $('#<%=Hiddentd.ClientID%>').val();
        //   $("#" + hidnid + "").css('background-color', 'white');
        $('#div_testName,#div_patient').empty();
        $("#" + tdid + "").css('background-color', 'yellow');
        $('#<%=Hiddentd.ClientID%>').val(tdid);
        var _CentreID = "";
        $('#<%=lstCentreAccess.ClientID%> :selected').each(function (i, selected) {
            if (_CentreID == "") {
                _CentreID = $(selected).val();
            }
            else {
                _CentreID = _CentreID + "," + $(selected).val();
            }
        });
        var _PanelID = "";
        $('#<%=ddlPanel.ClientID%> :selected').each(function (i, selected) {
            if (_PanelID == "") {
                _PanelID = $(selected).val();
            }
            else {
                _PanelID = _PanelID + "," + $(selected).val();
            }
        });       

        var _DoctorID = "";
        $('#<%=ddlDoctor.ClientID%> :selected').each(function (i, selected) {
            if (_DoctorID == "") {
                _DoctorID = $(selected).val();
            }
            else {
                _DoctorID = _DoctorID + "," + $(selected).val();
            }
        });
        var _CategoryID = "";
        $('#<%=ddlCategory.ClientID%> :selected').each(function (i, selected) {
            if (_CategoryID == "") {
                _CategoryID = $(selected).val();
            }
            else {
                _CategoryID = _CategoryID + "," + $(selected).val();
            }
        });       

        var _Department = "";
        $('#<%=ddlDepartment.ClientID%> :selected').each(function (i, selected) {
            if (_Department == "") {
                _Department = $(selected).val();
            }
            else {
                _Department = _Department + "," + $(selected).val();
            }
        });       

        serverCall('Doctor_MIS.aspx/showPatientData', { dtFrom: $("#<%=dtFrom.ClientID %>").val(), dtTo: $("#<%=dtTo.ClientID %>").val(), DoctorID: ID, _getSelectedPanel: _PanelID, _getSelectedCentre: _CentreID, _Category: _CategoryID, _Department: _Department }, function (response) {
            if (response == "0") {
                toast("Info", "No Record Found..!", "");
            }
            else {
                $("#div_patient").show();
                EmpData = jQuery.parseJSON(response);
                var output = $('#PatientShow').parseTemplate(EmpData);
                $('#div_patient').html(output);
            }
        });
    }
        var testInfo = "";
        function ViewTestDetails(ID, trid, e) {
            $("#j" + trid + "").css('background-color', 'yellow');
            $('#<%=Hiddentrtest.ClientID%>').val('j' + trid);
            $('#div_testName').empty();
            var MasterShare = $("#<%=_valueMastershare.ClientID%>").val();
            var Doct_id = $("#<%=_Doct_IdHidn.ClientID%>").val();
            serverCall('Doctor_MIS.aspx/showTestData', { LabID: ID }, function (response) {
                if (response == "0") {
                    toast("Error", "contact to itdose", "");
                }
                else if (response == null) {
                    toast("Info", "No Record found..!", "");
                }
                else {                    
                    $("#div_testName").show();
                    testInfo = jQuery.parseJSON(response);                  
                    var output = $('#Test_Info').parseTemplate(EmpData);
                    $('#div_testName').html(output);
                }
            });
        }      
        function addDoctorDropDownList() {           
            $("#<%=ddlRefDoc.ClientID %> option").remove();
            $("#tb_grdLabSearch tr").find('#chk').filter(':checked').each(function () {
                var a = $(this).closest('tr').find("#Doctor_ID").text();
                var b = $(this).closest('tr').find("#DoctorName").text();
                $("#<%=ddlRefDoc.ClientID %>").append($("<option></option>").val(a).html(b));
            });
        }
        function MergeDoctors() {
            var favorite = [];
            $.each($("input[name='sport']:checked"), function () {
                favorite.push($(this).val());
            });
            var ids = favorite.join(", ");
            var doctr_select = $("#<%=ddlRefDoc.ClientID%>").val();
            var FinalDocID = document.getElementById('<%=ddlRefDoc.ClientID %>').options[document.getElementById('<%=ddlRefDoc.ClientID %>').selectedIndex].text;
            serverCall('Doctor_MIS.aspx/DoctorMerge', { proid: ids, doc_select: doctr_select }, function (response) {
                var $responseData = JSON.parse(response);
                $("#<%=ddlDoctor.ClientID%>").html('');               
                if ($responseData.status) {
                    var storedata = eval('[' + response + ']');                   
                        SearchDoctorSummary();                       
                        toast("Success", "Successfully Merge Doctor", "");                    
                }
                else {
                    toast("Error", $responseData.response, "");
                }
            });           
        }
        function UpdateReff(ctrl, DoctorID) {            
            var $Checkvalue = jQuery(ctrl).closest('tr').find('#chkRef').is(':checked') ? 1 : 0;
            serverCall('Doctor_MIS.aspx/DoctorRefferal', { DoctorID: DoctorID, CheckValue: $Checkvalue }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast("Success", $responseData.response, '');                   
                    $("#<%=ddlDoctor.ClientID%>").html('');   
                    SearchDoctorSummary();
                }
                else {
                    toast("Error", $responseData.response, '');
                }
            });           
        }

        function UpdateShareMaster(ctrl, DoctorID) {
            var $Checkvalue = jQuery(ctrl).closest('tr').find('#chkMasterShare').is(':checked') ? 1 : 0;
            serverCall('Doctor_MIS.aspx/ShareMasterUpdate', { DoctorID: DoctorID, CheckValue: $Checkvalue }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast("Success", $responseData.response, "");
                    SearchDoctorSummary();
                }
                else {
                    toast("Error", $responseData.response, "");
                }
            });
        }
        function Doctor_Reports() {
            var allDocID = $("#<%=Doct_ID_hiddn.ClientID%>").val();
            try {
                var querytype = "";
                var rb = document.getElementById("<%=rblReportType.ClientID%>");
                var radio = rb.getElementsByTagName("input");
                var label = rb.getElementsByTagName("label");
                for (var i = 0; i < radio.length; i++) {
                    if (radio[i].checked) {
                        querytype = radio[i].value;
                        break;
                    }
                }
				var querytype1 = "";
                var rb1 = document.getElementById("<%=rblReportFormate.ClientID%>");
                var radio1 = rb1.getElementsByTagName("input");
                var label1 = rb1.getElementsByTagName("label");
                for (var i = 0; i < radio1.length; i++) {
                    if (radio1[i].checked) {
                        querytype1 = radio1[i].value;
                        break;
                    }
                }
                if (allDocID == "") {                    
                    toast("Info", "Please Select the Check box.", "");
                    return false;
                }
                var _CentreID = "";
                $('#<%=lstCentreAccess.ClientID%> :selected').each(function (i, selected) {
                    if (_CentreID == "") {
                        _CentreID = $(selected).val();
                    }
                    else {
                        _CentreID = _CentreID + "," + $(selected).val();
                    }
                });
                var _PanelID = "";
                $('#<%=ddlPanel.ClientID%> :selected').each(function (i, selected) {
                    if (_PanelID == "") {
                        _PanelID = $(selected).val();
                    }
                    else {
                        _PanelID = _PanelID + "," + $(selected).val();
                    }
                });
                var _Printseparate = $("#<%=chkprintsaperate.ClientID%>").is(':checked') ? 1 : 0;

                var _DoctorID = "";
                $('#<%=ddlDoctor.ClientID%> :selected').each(function (i, selected) {
                    if (_DoctorID == "") {
                        _DoctorID = $(selected).val();
                    }
                    else {
                        _DoctorID = _DoctorID + "," + $(selected).val();
                    }
                });
                var _CategoryID = "";
                $('#<%=ddlCategory.ClientID%> :selected').each(function (i, selected) {
                    if (_CategoryID == "") {
                        _CategoryID = $(selected).val();
                    }
                    else {
                        _CategoryID = _CategoryID + "," + $(selected).val();
                    }
                });
                var _HeadDepartment = "";

                var _Department = "";
                $('#<%=ddlDepartment.ClientID%> :selected').each(function (i, selected) {
                    if (_Department == "") {
                        _Department = $(selected).val();
                    }
                    else {
                        _Department = _Department + "," + $(selected).val();
                    }
                });
                var _Area = "";
                $('#<%=Area_text.ClientID%> :selected').each(function (i, selected) {
                    if (_Area == "") {

                        _Area = $(selected).val();

                    }
                    else {

                        _Area = _Area + "," + $(selected).val();
                    }
                });
                var _Spclization = "";
                $('#<%=lsDoctorSpl.ClientID%> :selected').each(function (i, selected) {
                    if (_Spclization == "") {
                        _Spclization = $(selected).val();
                    }
                    else {
                        _Spclization = _Spclization + "," + $(selected).val();
                    }
                });
                var per1 = $("#<%=per1.ClientID%>").val();
                var val1 = $("#<%=val1.ClientID%>").val();
                var per2 = $("#<%=per2.ClientID%>").val();
                var val2 = $("#<%=val2.ClientID%>").val();
                var share1 = $("#<%=shareAmount1.ClientID%>").val();
                var share2 = $("#<%=shareAmount2.ClientID%>").val();
                var isReffDrop = $("#<%=IsReffDropdown.ClientID%>").val();
                var Doct_Mobile = $("#<%=Doc_phn.ClientID%>").val();

                serverCall('Doctor_MIS.aspx/DoctorSummaryReport', { dtFrom: $("#<%=dtFrom.ClientID %>").val(), dtTo: $("#<%=dtTo.ClientID %>").val(), CentreID: _CentreID, PanelID: _PanelID, Printseparate: _Printseparate, DoctorID: allDocID, CategoryID: _CategoryID, HeadDepartmentID: _HeadDepartment, DepartmentID: _Department, parm1: per1, val1: val1, parm2: per2, val2: val2, shareAmount1: share1, shareAmount2: share2, Area: _Area, Speclization: _Spclization, ReportType: querytype, IsReff: isReffDrop, Doct_Mobile: Doct_Mobile,ReportFormate:querytype1 }, function (response) {
                    var $responseData = JSON.parse(response);
                    if (querytype == "4") {
                        PostQueryString($responseData, '../DocAccount/DoctorEnvelopes.aspx');
                    }
                    else {
                        PostQueryString($responseData, '../DocAccount/DocAccountReport.aspx');
                    }
                });
            } catch (e) {
            }
        };
      
        function check_uncheck_checkbox(isChecked) {
            if (isChecked) {
                $("#Doc_Merge").hide();
                $('input[name="sport"]').each(function() { 
                    this.checked = true; 
                });
            } else {
                $("#Doc_Merge").show();
                $("#<%=ddlRefDoc.ClientID %> option").remove();
                $('input[name="sport"]').each(function() {
                    this.checked = false;
                });
            }
        }
        $(function () {
            //called when key is pressed in textbox
            $("#<%=shareAmount2.ClientID%>").keypress(function (e) {
                //if the letter is not digit then display error and don't type anything
                if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {                   
                    return false;
                }
            });
            $("#<%=val1.ClientID%>").keypress(function (e) {
                //if the letter is not digit then display error and don't type anything
                if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
                    return false;
                }
            });
        });
        function updateshare(ctrl,ItemID, Labno) {
            var $Chkvalue = jQuery(ctrl).closest('tr').find('#chkshare').is(':checked') ? 1 : 0;
            serverCall('Doctor_MIS.aspx/updateDocshare', { ItemID: ItemID, labNo: Labno, Chkvalue: $Chkvalue }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast("Success", $responseData.response, "");
                }
                else {
                    toast("Error", $responseData.response, "");
                }
            });
        }
         </script>   
   <Ajax:ScriptManager AsyncPostBackErrorMessage="Error..." ID="ScriptManager1" runat="server"> 
     </Ajax:ScriptManager> 
  <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div class="row" style="text-align: center;">
                <div class="col-md-24">
                <b>Doctor MIS Report</b>               
                    </div>
                </div>
        </div>
        <div  id="SearchDiv" class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-2">From Date : </div>
                <div class="col-md-4">
                     <asp:TextBox ID="dtFrom" runat="server" ReadOnly="true" Width="100px"></asp:TextBox>                       
                    <cc1:CalendarExtender runat="server" ID="ce_dtfrom"  TargetControlID="dtFrom" Format="dd-MMM-yyyy" PopupButtonID="dtFrom" />
                </div>
                <div class="col-md-2">To Date :</div>
                <div class="col-md-4">
                   <asp:TextBox ID="dtTo" runat="server" ReadOnly="true"  Width="100px"></asp:TextBox>                      
                        <cc1:CalendarExtender runat="server" ID="ce_dtTo" TargetControlID="dtTo" Format="dd-MMM-yyyy" PopupButtonID="dtTo" />
                </div>
                <div class="col-md-2">Centre :</div>
                <div class="col-md-4">
                    <asp:ListBox ID="lstCentreAccess" runat="server" CssClass="multiselect" SelectionMode="Multiple"></asp:ListBox>
                </div>
                <div class="col-md-2">Panel :</div>
                <div class="col-md-4">
                    <asp:ListBox ID="ddlPanel" runat="server"   CssClass="multiselect" SelectionMode="Multiple"></asp:ListBox>
                </div>
            </div>
             <div class="row">
                  <div class="col-md-2">Category :</div>
                <div class="col-md-4"><asp:ListBox ID="ddlCategory" runat="server"  CssClass="multiselect" SelectionMode="Multiple"></asp:ListBox></div>
                 <div class="col-md-2">Department :</div>
                 <div class="col-md-4"><asp:ListBox ID="ddlDepartment" runat="server"  CssClass="multiselect" SelectionMode="Multiple"></asp:ListBox></div>
                 <div class="col-md-2">Doctor:</div>
                 <div class="col-md-4"><asp:ListBox ID="ddlDoctor"  runat="server"  CssClass="multiselect" SelectionMode="Multiple"></asp:ListBox></div>
                 <div class="col-md-2"><asp:CheckBox ID="ShowMorechk" runat="server" Text="Show More" /></div>
                 <div class="col-md-4"><asp:CheckBox ID="chkprintsaperate" runat="server" Text="Print Separate" /></div>
            </div>
              <div class="row" id="tr1" style="display:none">
                   <div class="col-md-2">PatientCount:</div>
                <div class="col-md-4">
                    <asp:DropDownList ID="per1" runat="server" Width="100px"> <asp:ListItem Selected="True">=</asp:ListItem>
                                        <asp:ListItem>>=</asp:ListItem>
                                        <asp:ListItem><=</asp:ListItem>
                                        <asp:ListItem>></asp:ListItem>
                                        <asp:ListItem><</asp:ListItem>
                                        <asp:ListItem>between</asp:ListItem></asp:DropDownList>&nbsp;&nbsp;<asp:TextBox ID="val1" style="width:35px" runat="server"></asp:TextBox>&nbsp;  <asp:DropDownList ID="per2" runat="server" style="display:none"><asp:ListItem><</asp:ListItem><asp:ListItem><=</asp:ListItem><asp:ListItem>=</asp:ListItem></asp:DropDownList>&nbsp;&nbsp;<asp:TextBox ID="val2" style="width:20px;display:none" runat="server"></asp:TextBox>
                </div>
                   <div class="col-md-2">Ref Amount:</div>
                  <div class="col-md-4"><asp:DropDownList ID="shareAmount1" runat="server"  Width="100px"> 
                         <asp:ListItem Selected="True">=</asp:ListItem>
                                        <asp:ListItem>>=</asp:ListItem>
                                        <asp:ListItem><=</asp:ListItem>
                                        <asp:ListItem>></asp:ListItem>
                                        <asp:ListItem><</asp:ListItem>
                                        <asp:ListItem>between</asp:ListItem></asp:DropDownList>&nbsp;&nbsp;<asp:TextBox ID="shareAmount2" style="width:50px" runat="server"></asp:TextBox>&nbsp;</div>
                   <div class="col-md-2">Mobile No:</div>
                  <div class="col-md-4"><asp:TextBox ID="Doc_phn" class="ms-choice" style="width:200px" runat="server"></asp:TextBox></div>
                   <div class="col-md-2">Doctor Spl:</div>
                  <div class="col-md-4"><asp:ListBox ID="lsDoctorSpl" runat="server" CssClass="multiselect" SelectionMode="Multiple"></asp:ListBox></div>
                  </div>
             <div class="row" id="tr2" style="display:none">
                 <div class="col-md-2">Area:</div>
                <div class="col-md-4"><asp:ListBox ID="Area_text" runat="server" CssClass="multiselect" SelectionMode="Multiple"></asp:ListBox></div>
                  <div class="col-md-6"></div>
                  <div class="col-md-6"></div>
                 <div class="col-md-2">IsRef:</div>
                  <div class="col-md-4"><asp:DropDownList ID="IsReffDropdown" Width="100px" runat="server"><asp:ListItem>BOTH</asp:ListItem>
                           <asp:ListItem>Y</asp:ListItem>
                           <asp:ListItem>N</asp:ListItem>
                       </asp:DropDownList></div>
                  </div>
             <div class="row" style="text-align: center">
                <div class="col-md-24"><input id="btnSearch" type="button" value="Search" onclick="SearchDoctorSummary()"  class="searchbutton" style="width:100px;" "/></div>                 
                  </div>         
            </div> 
      <div  id="Doc_report" class="POuter_Box_Inventory" style="display:none"> 
      <div class="row">
                <div class="col-md-18">
                     <asp:RadioButtonList ID="rblReportType" runat="server" RepeatColumns="6" RepeatDirection="Horizontal" >  
                           <asp:ListItem Value="0" style="display:none">Item Wise</asp:ListItem>
                            <asp:ListItem Value="1" Selected="True">Patient Wise</asp:ListItem>
                            <asp:ListItem Value="2" style="display:none">Doctor Wise</asp:ListItem> 
                         <asp:ListItem Value="3" style="display:none">Department Wise</asp:ListItem>                                                                                                   
                        <asp:ListItem Value="4" style="display:none" >Print Envelopes</asp:ListItem>                                                                                            
                    </asp:RadioButtonList>
                    </div>
					<div class="col-md-18">
                     <asp:RadioButtonList ID="rblReportFormate" runat="server" RepeatColumns="6" RepeatDirection="Horizontal" >  
                           <asp:ListItem Value="0" Selected="True">PDF</asp:ListItem>
                            <asp:ListItem Value="1">EXCEL</asp:ListItem>                                               
                    </asp:RadioButtonList>
                    </div>
          <div class="col-md-6">
              <input type="button" value="Show_Report" onclick="Doctor_Reports();" class="searchbutton" id="btn_show" />
              </div>
          </div>
          </div>            
      <div  id="Doc_Merge" class="POuter_Box_Inventory" style="display:none">
           <div class="row">
                <div class="col-md-18">
                     <asp:DropDownList ID="ddlRefDoc" runat="server" style="width:200px"></asp:DropDownList>
                    </div>               
                <div class="col-md-6">
                     <input id="Button2" type="button" value="Merge" onclick="MergeDoctors()"  class="searchbutton" style="width:100px;display:none;" "/>
                    </div>
               </div>                
             </div>
             <div class="POuter_Box_Inventory" style="width:99.6%">
            <div class="Purchaseheader">                 
                Search Result<div id="GrandTotal" style="display:none;font-weight:bold;color:black;float:right;background-color:lightgreen;">Total <span id="myid"></span> </div></div>
           <div id="div_Data" style="max-height:350px; overflow:auto;width:99.6%;"></div>  
                
              </div>
      <div class="row">
          <div id="div_patient" style="height:480px;display:none" class="column">
                       </div>

           <div id="div_testName" class="column1" style="display:none">
                       </div>

      </div>
      <asp:HiddenField ID="Hiddentd" runat="server" />
      <asp:HiddenField ID="Hiddentrtest" runat="server" />
      <asp:GridView ID="GridView1" runat="server"></asp:GridView>
  <script id="tb_InvestigationItems" type="text/html">
    
   <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch" 
    style="border-collapse:collapse;width:100%;background-color:white">
		<tr id="Tr1" style="background-color:black;height:30px">
		    <th class="GridViewHeaderStyle" scope="col" style="width:20px;display:none;">View</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:20px">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:20px">Ref</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:20px">Count</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:53px">Select <input type="checkbox" id="checkAll" onclick="check_uncheck_checkbox(this.checked);"/></th>
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">Doc Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Master Share</th>		
            <th class="GridViewHeaderStyle" scope="col" style="width:150px;">Phone</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:150px;">phone1</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Mobile</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Area</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Share Amount</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Added On</th>				
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;"> Show</th>
			
		</tr>

       <#
              var dataLength=PatientData.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow; 
       var str;
       var SumReff=0;
       var sumCount=0;
       var Doct_ID="";
       var _DocCount=0;
             for(var j=0;j<dataLength;j++)
               {
                  objRow = PatientData[j];
               
            #>
                
<tr id="<#=j+1#>" style="background-color:white">
<td class="GridViewLabItemStyle" ><#=j+1#></td>
    <td class="GridViewLabItemStyle" id="td1">
    <#if(objRow.Referal=="Y")
    {#>
     <input type="checkbox" id="chkRef" onclick="UpdateReff(this,'<#=objRow.Doctor_ID1#>')" checked="checked" />
    <#}
    else{#>
     <input type="checkbox" id="chkRef" onclick="UpdateReff(this,'<#=objRow.Doctor_ID1#>')" />
   <#}#>
         </td>
       <td class="GridViewLabItemStyle" id="Doctor_ID" style="display:none;" ><#=objRow.Doctor_ID1#></td>
    
    <td class="GridViewLabItemStyle"  id="tdInvoiceDate"><#=objRow.Total#></td>
    <td class="GridViewLabItemStyle" ><input id="chk" type="checkbox" name="sport" onclick="addDoctorDropDownList()" value="<#=objRow.Doctor_ID1#>"  /></td>
    <td id="DoctorName"  class="GridViewLabItemStyle"><#=objRow.Doctor#></td>
    <td class="GridViewLabItemStyle"  id="td16">
     <#if(objRow.MasterShare=="Y")
    {#>
     <input type="checkbox" id="chkMasterShare" onclick="UpdateShareMaster(this, '<#=objRow.Doctor_ID1#>')"  checked="checked" />
     <#}
    else{#>
     <input type="checkbox" id="chkMasterShare" onclick="UpdateShareMaster(this, '<#=objRow.Doctor_ID1#>')"  />
   <#}#>
         </td>
     <td id="PanelName"  class="GridViewLabItemStyle" ><#=objRow.Phone#></td>   
     <td id="Td2"  class="GridViewLabItemStyle"><#=objRow.Phone2#></td>
     <td id="tdGrossAmount"  class="GridViewLabItemStyle" ><#=objRow.Mobile#></td>
     <td id="tdDisAmount"  class="GridViewLabItemStyle" ><#=objRow.AREA#></td>
     <td id="tdInvoiceAmount"  class="GridViewLabItemStyle" style="font-weight:bold;text-align:right"><#=objRow.SharedAmount#></td>
     <td id="tdNetAmount"  class="GridViewLabItemStyle" ><#=objRow.AddedDate#></td>
     <td id="td3"  class="GridViewLabItemStyle" style="font-weight:bold;text-align:center"> <img id="img1" alt="" src="../../App_Images/view.gif" style="cursor:pointer;"
             onclick="ViewPatient('<#=objRow.Doctor_ID#>',<#=j+1#>,'<#=objRow.MasterShare#>','<#=objRow.Doctor_ID1#>',this)"/></td>
</tr>
<#
               _DocCount=parseFloat(_DocCount)+1  ;
                 if(objRow.SharedAmount!="")
                 SumReff+=parseFloat(objRow.SharedAmount);#>
                <# if(objRow.Total!="")
                 sumCount+=parseFloat(objRow.Total);#> 
            <#}#>
<span style="float:right;background-color:white"><b>Total Doctor Count : <#=_DocCount.toFixed(2)#>,Total Patient Count : <#=sumCount#>,Total Shared Amount : <#=SumReff.toFixed(2)#></b></span>
                 <asp:HiddenField ID="Doct_ID_hiddn" runat="server"></asp:HiddenField>
                 <asp:HiddenField ID="_valueMastershare" runat="server"></asp:HiddenField>
                  <asp:HiddenField ID="_Doct_IdHidn" runat="server"></asp:HiddenField>
         <input type="hidden" value="<#=Doct_ID#>" id="hidden" />       
   </table>
          
    </script>
      <script id="PatientShow" type="text/html">
    
   <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="Table1" 
    style="border-collapse:collapse;width:100%">
         <thead class="fixedHeader">
		<tr id="Header" style="background-color:black;">		    
            <th class="GridViewHeaderStyle" scope="col" style="width:20px">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:20px">LabNo.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:20px">VisitDate</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">Patient</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:150px;">GrossAmount</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:150px;">Discount</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">NetAmount</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">PaidAmount</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Balance</th>							
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;"> Show
			</th>
		</tr>
</thead>
<tbody class="scrollContent">
       <#
              var dataLength=EmpData.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow; 
             for(var j=0;j<dataLength;j++)
               {
                  objRow = EmpData[j];
                
            #>
                
<tr id="j<#=j+1#>" style="background-color:white">
<td class="GridViewLabItemStyle" ><#=j+1#></td>
    <td class="GridViewLabItemStyle" id="td4"><#=objRow.PatientID#></td> 
    <td class="GridViewLabItemStyle" id="td5"><#=objRow.dtEntry#></td>
    <td id="Td6"  class="GridViewLabItemStyle" ><#=objRow.Patient#></td>
    <td id="Td7"  class="GridViewLabItemStyle" style="text-align:right"><#=objRow.GrossAmount#></td>    
    <td id="Td8"  class="GridViewLabItemStyle" style="text-align:right"><#=objRow.DiscountOnTotal#></td>
    <td id="td10" class="GridViewLabItemStyle" style="text-align:right"><#=objRow.NetAmount#></td>
    <td id="td18" class="GridViewLabItemStyle" style="text-align:right"><#=objRow.FinalAdjustment#></td>
    <td id="td9"  class="GridViewLabItemStyle" style="text-align:right"><#=objRow.Balance#></td>
    <td id="td13" class="GridViewLabItemStyle" style="font-weight:bold;text-align:center"> <img id="img2" alt="" src="../../App_Images/view.gif" style="cursor:pointer;"
             onclick="ViewTestDetails('<#=objRow.LedgerTransactionID#>',<#=j+1#>,this)"/></td>
</tr>
            <#}#>
     </table>     
    </script>
      <script id="Test_Info" type="text/html">   
   <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="Table2" 
    style="border-collapse:collapse;width:100%">
		<tr id="Tr5" style="background-color:black;">		    
            <th class="GridViewHeaderStyle" scope="col" style="width:10px">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px">Test Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:20px">ShareAmt</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:20px;">Amount</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:20px;">#</th>	            										
		</tr>
       <#
              var dataLength=testInfo.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow; 
             for(var j=0;j<dataLength;j++)
               {
                  objRow = testInfo[j];               
            #>
                
    <tr id="Tr6" style="background-color:white">
    <td class="GridViewLabItemStyle" ><#=j+1#></td>
    <td class="GridViewLabItemStyle"  id="td11"><#=objRow.Item#></td>  
    <td class="GridViewLabItemStyle" style="text-align:right" id="td12"><#=objRow.DoctorShare#></td>
    <td id="Td14"  class="GridViewLabItemStyle" style="text-align:right"><#=objRow.Amount#></td>
    <td class="GridViewLabItemStyle">
           <#if(objRow.RemoveDocShareItemWise=="0")
    {#>
         <input id="chkshare" type="checkbox" checked="checked" onclick="updateshare(this,'<#=objRow.itemid#>', '<#=objRow.PatientID#>')" />
          <#}
    else{#>
         <input id="chkshare" type="checkbox"  onclick="updateshare(this,'<#=objRow.itemid#>', '<#=objRow.PatientID#>')" />
          <#}#>
     </td>
</tr>

            <#}#>

     </table>     
    </script>
    
     </div>
   
</asp:Content>