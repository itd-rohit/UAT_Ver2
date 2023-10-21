<%@ Page Title="" ClientIDMode="Static" Language="C#"  AutoEventWireup="true" CodeFile="ReportMaster_Access.aspx.cs" Inherits="Design_Master_ReportMaster_Access" %>

<!DOCTYPE html>
<webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" />

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>  
    <%: Scripts.Render("~/bundles/WebFormsJs") %>  
    <script type="text/javascript" src="../../Scripts/CheckboxSearch.js"></script>
</head>
<body>
    <form id="form1" runat="server">                 
         <div class="POuter_Box_Inventory">
            <div  style="text-align: center;">
                <div class="col-md-24">
                <b>Report Access Master</b><br />
                    <asp:Label ID="lblReportname" Font-Bold="true" runat="server"></asp:Label>               
                    </div>
                </div>
        </div>         
     <div class="POuter_Box_Inventory">
          <div class="row">
                        <div class="col-md-12">
                <div class="Purchaseheader">
                    <div class="row">
                        <div class="col-md-24">
                            Centre
                        </div>
                        </div>                        
                    </div>                   
                     <div id="div2" style="overflow-y: scroll; height: 190px; text-align: left;">
                    <table id="tblcentre"> 
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 260px">Centre Name</th>
                                 <th class="GridViewHeaderStyle" scope="col">Access Day</th>
                                 <th class="GridViewHeaderStyle" scope="col">Access in Day</th>
                                 <th class="GridViewHeaderStyle" scope="col">PDF<input type="checkbox" id="chkpdfcentre" onclick="chkallcentrepdf();"> </th>
                                 <th class="GridViewHeaderStyle" scope="col">Excel<input type="checkbox" id="chkcentreexcel" onclick="chkallcentreexcel();"></th>                               
                                <th class="GridViewHeaderStyle" scope="col">Active</th>
                            </tr>    
                            </thead>                      
                        <tbody id="tblcentrebody"></tbody>                                      
                    </table>
                </div>  
                             </div>
                <div class="col-md-12">
                    <div class="Purchaseheader">
                    <div class="row">
                        <div class="col-md-24">
                            Role
                        </div>                        
                    </div>
                 

                </div>
                     <div id="div3" style="overflow-y: scroll; height: 190px; text-align: left;">
                    <table id="tblrole"> 
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 240px">Role Name</th>
                                 <th class="GridViewHeaderStyle" scope="col">Access Day</th>
                                 <th class="GridViewHeaderStyle" scope="col">Access in Day</th>
                                 <th class="GridViewHeaderStyle" scope="col">PDF<input type="checkbox" id="chkrolepdf" onclick="chkallrolepdf();"></th>
                                 <th class="GridViewHeaderStyle" scope="col">Excel<input type="checkbox" id="chkrolecentre" onclick="chkallroleexcel();"></th>                               
                                <th class="GridViewHeaderStyle" scope="col">Active</th>
                            </tr>    
                            </thead>                      
                        <tbody id="tblrolebody"></tbody>                                      
                    </table>
                </div> 
                    </div>
               </div>                
            </div>        
        
          <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    <div class="row">
                        <div class="col-md-4">
                            Employee
                        </div>
                        <div class="col-md-6">Search :<input id="txtEmployee" placeholder="Search Employee" style="width: 150px" />
                        </div>                       
                    </div>


                </div>

                <div id="divEmplist" style="overflow-y: scroll; height: 175px; text-align: left;">
                    <table id="tblEmp">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 260px">Employee Name</th>
                                 <th class="GridViewHeaderStyle" scope="col">Access Day</th>
                                 <th class="GridViewHeaderStyle" scope="col">Access in Day</th>
                                 <th class="GridViewHeaderStyle" scope="col">PDF</th>
                                 <th class="GridViewHeaderStyle" scope="col">Excel</th>
                               
                                <th class="GridViewHeaderStyle" scope="col">Remove</th>
                            </tr>
                        </thead>
                        <tbody id="tbltbody">
                        </tbody>
                    </table>
                </div>
                 <div class="POuter_Box_Inventory" style="text-align: center">
                <input type="button" id="btnSave" class="ItDoseButton" value="Save" onclick="$saveDetails();" />
            </div>
            </div>
                 
          </form>
</body>
    <script type="text/javascript">              
        $(function () {
            function split(val) {
                return val.split(/,\s*/);
            }
            function extractLast(term) {
                return split(term).pop();
            }

            $("#txtEmployee").bind("keydown", function (event) {
                if (event.keyCode === $.ui.keyCode.TAB &&
                    $(this).autocomplete("instance").menu.active) {
                    event.preventDefault();
                }
            }).autocomplete({
                source: function (request, response) {
                    $.getJSON("../Common/CommonjsonData.aspx?cmd=GetEmployee", {
                        term: extractLast(request.term)
                    }, response);
                },
                search: function () {
                    var term = extractLast(this.value);
                    if (term.length < 2) {
                        return false;
                    }
                },
                focus: function () {
                    return false;
                },
                select: function (event, ui) {
                    this.value = "";
                    CreateDynamicTable(ui.item.id, ui.item.value)
                    return false;
                }
            });
        });

        function CreateDynamicTable(employeeID, EmployeeName) {
            var IsValid = true;
            $("#tblEmp tbody tr").each(function () {
                if (employeeID == $(this).closest('tr').find("#hdnId").val()) {
                    IsValid = false;
                }
            });

            if (!IsValid) {
                toast("Error", "Already selected");
                return false;
            }

            var output = [];
            output.push('<tr id="tr_');
            output.push('">');
            output.push('</td>');
            output.push('<td id="tdDocName"  class="GridViewLabItemStyle"  style="width:100px;">');
            output.push('<input type="hidden" id="hdnId" value="');
            output.push(employeeID);
            output.push('"/>');
            output.push(EmployeeName); output.push('</td>');
            output.push('<td class="GridViewLabItemStyle">');
            output.push('<input type="checkbox" id="chkaccessinday"  onclick="enableday(this);" />'); output.push('</td>');
            output.push('<td  class="GridViewLabItemStyle">');
            output.push('<input type="text" onkeyup="txtRateVal(this);" disabled=true style="width:100px"  id="txtduration"/>'); output.push('</td>');
            output.push('<td class="GridViewLabItemStyle">');
            output.push('<input type="checkbox" id="chkpdf" />'); output.push('</td>');
            output.push('<td  class="GridViewLabItemStyle">');
            if ('<%=ReportID%>' != "2") {
                output.push('<input type="checkbox" id="chkexcel"/>');
            }
                output.push('</td>');
           
            output.push('<td id="chkbox"class="GridViewLabItemStyle"  Style="width:10px;"><img style="cursor: pointer;" alt="upload pdf" src="../../App_Images/Delete.gif"  onclick="Remove(this)"   /> </td>');
            output.push('</tr>');
            output = output.join('');
            $("#tbltbody").append(output);
        }

        function Remove(ctr) {
            $(ctr).closest('tr').remove();
        }
        function chkallcentrepdf() {
            if ($('#chkpdfcentre').is(':checked')) {
                $('#tblcentre tr').each(function () {
                    $(this).closest('tr').find('#chkpdf').prop('checked', true);
                });
            }
            else {
                $('#tblcentre tr').each(function () {
                    $(this).closest('tr').find('#chkpdf').prop('checked', false);
                });
            }
        } 
        function chkallcentreexcel() {
            if ($('#chkcentreexcel').is(':checked')) {
                $('#tblcentre tr').each(function () {
                    $(this).closest('tr').find('#chkexcel').prop('checked', true);
                });
            }
            else {
                $('#tblcentre tr').each(function () {
                    $(this).closest('tr').find('#chkexcel').prop('checked', false);
                });
            }
        }
        function chkallrolepdf() {
            if ($('#chkrolepdf').is(':checked')) {
                $('#tblrole tr').each(function () {
                    $(this).closest('tr').find('#chkpdf').prop('checked', true);
                });
            }
            else {
                $('#tblrole tr').each(function () {
                    $(this).closest('tr').find('#chkpdf').prop('checked', false);
                });
            }
        }
        function chkallroleexcel() {
            if ($('#chkrolecentre').is(':checked')) {
                $('#tblrole tr').each(function () {
                    $(this).closest('tr').find('#chkexcel').prop('checked', true);
                });
            }
            else {
                $('#tblrole tr').each(function () {
                    $(this).closest('tr').find('#chkexcel').prop('checked', false);
                });
            }
        }
        function GetDetails() {
            debugger;
            var _details = [];
            var objdata = {};
                      

            $("#tblcentre tbody tr").each(function () {                
                    objdata = {};
                    objdata.ReportID = '<%=ReportID%>';
                    objdata.AccessType = "CentreId";
                    objdata.AccessTypeto = $(this).closest('tr').find('#hdnId').val();
                    objdata.DurationInDay = $(this).closest('tr').find('#txtduration').val() != "" ? $(this).closest('tr').find('#txtduration').val() : 0;
                    objdata.ShowPdf = $(this).closest('tr').find('#chkpdf').is(':checked') ? 1 : 0;
                    objdata.ShowExcel = $(this).closest('tr').find('#chkexcel').is(':checked') ? 1 : 0;
                    objdata.Active = $(this).closest('tr').find('#chkactive').is(':checked') ? 1 : 0;
                    _details.push(objdata);
                
              });
            $("#tblrole tbody tr").each(function () {                
                    objdata = {};
                    objdata.ReportID = '<%=ReportID%>';
                    objdata.AccessType = "RoleId";
                    objdata.AccessTypeto = $(this).closest('tr').find('#hdnId').val();
                    objdata.DurationInDay = $(this).closest('tr').find('#txtduration').val() != "" ? $(this).closest('tr').find('#txtduration').val() : 0;
                    objdata.ShowPdf = $(this).closest('tr').find('#chkpdf').is(':checked') ? 1 : 0;
                    objdata.ShowExcel = $(this).closest('tr').find('#chkexcel').is(':checked') ? 1 : 0;
                    objdata.Active = $(this).closest('tr').find('#chkactive').is(':checked') ? 1 : 0;
                    _details.push(objdata);
                
             });


            $("#tblEmp tbody tr").each(function () {
                objdata = {};
                objdata.ReportID = '<%=ReportID%>';
                objdata.AccessType = "Employee_ID";
                objdata.AccessTypeto = $(this).closest('tr').find('#hdnId').val();
                objdata.DurationInDay = $(this).closest('tr').find('#txtduration').val() != "" ? $(this).closest('tr').find('#txtduration').val() : 0;
                objdata.ShowPdf = $(this).closest('tr').find('#chkpdf').is(':checked') ? 1 : 0;
                objdata.ShowExcel = $(this).closest('tr').find('#chkexcel').is(':checked') ? 1 : 0;
                objdata.Active = 1;
                _details.push(objdata);
            });
            return _details;

        }
        var $saveDetails = function () {                      
            var $reportDetail = GetDetails();
            serverCall('ReportMaster_Access.aspx/SaveReportAccess', { ReportDetail: $reportDetail, ReportID: '<%=ReportID%>' }, function (response) {

                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast("Success", "Record Saved Successfully", "");                    
                    $bindCentredata();
                    $bindRoledata();
                    $bindEmpdata();
                }
                else {
                    toast("Error", $responseData.ErrorMsg, "");
                }
                $modelUnBlockUI(function () { });

            });
        }
        var $bindEmpdata = function () {
            serverCall('ReportMaster_Access.aspx/getReportAccessDetails', { ReportID: '<%=ReportID%>', accessType: 'Employee_ID' }, function (response) {
                var $responseData = JSON.parse(response);
                $("#tbltbody").html('');
                if ($responseData.status) {

                    var _Empdata = $responseData.data;
                    var output = [];
                    for (var i = 0; i < _Empdata.length; i++) {
                        output.push('<tr id="tr_');
                        output.push('">');
                        output.push('</td>');
                        output.push('<td   class="GridViewLabItemStyle"  style="width:100px;">');
                        output.push('<input type="hidden" id="hdnId" value="');
                        output.push(_Empdata[i].Employee_ID); output.push('"/>'); output.push(_Empdata[i].Name); output.push('</td>');
                        output.push('<td class="GridViewLabItemStyle">');
                        output.push('<input type="checkbox" id="chkaccessinday"  onclick="enableday(this);"  ');
                        output.push('/>');
                        output.push('</td>');
                        output.push('<td  class="GridViewLabItemStyle">'); output.push('<input type="text"  disabled=true style="width:100px" onkeyup="txtRateVal(this);" id="txtduration" value="');
                        output.push(_Empdata[i].DurationInDay); output.push('"/>'); output.push('</td>');
                        output.push('<td class="GridViewLabItemStyle">'); output.push('<input type="checkbox" id="chkpdf" ');
                        if (_Empdata[i].ShowPdf == "1")
                            output.push('checked="checked"');
                        output.push('/>');
                        output.push('</td>');
                        output.push('<td  class="GridViewLabItemStyle">');
                        if ('<%=ReportID%>' != "2") {
                            output.push('<input type="checkbox" id="chkexcel"');
                            if (_Empdata[i].ShowExcel == "1")
                                output.push('checked="checked"');
                            output.push('/>');
                        }
                        output.push('</td>');
                        
                        output.push('<td id="chkbox"class="GridViewLabItemStyle"  Style="width:10px;"><img style="cursor: pointer;" alt="upload pdf" src="../../App_Images/Delete.gif"  onclick="Remove(this)"/> </td>');
                        output.push('</tr>');
                    }
                    output = output.join('');
                    $("#tbltbody").html(output);
                }
                $modelUnBlockUI(function () { });
            });
        }
        function enableday(ctrl) {           
            if ($(ctrl).closest('tr').find('#chkaccessinday').prop('checked') == true)
                $(ctrl).closest('tr').find('#txtduration').prop('disabled', false);
            else
                $(ctrl).closest('tr').find('#txtduration').prop('disabled', true);
        }
        function $bindCentredata() {
            serverCall('ReportMaster_Access.aspx/getReportAccessDetails', { ReportID: '<%=ReportID%>', accessType: 'CentreId' }, function (response) {
                var $responseData = JSON.parse(response);
                $("#tblcentrebody").html('');
                 if ($responseData.status) {
                    
                     var _Empdata = $responseData.data;
                     var output = [];
                     for (var i = 0; i < _Empdata.length; i++) {
                         output.push('<tr id="' + parseInt(i + 1) + '" ');
                         if (_Empdata[i].Active == "1")
                         output.push('style="background-color:lightgreen"')
                         output.push('>');                      
                         output.push('<td  class="GridViewLabItemStyle"  style="width:100px;">');
                         output.push('<input type="hidden" id="hdnId" value="');
                         output.push(_Empdata[i].CentreID); output.push('"/>'); output.push(_Empdata[i].Name); output.push('</td>');
                         output.push('<td class="GridViewLabItemStyle">');
                         output.push('<input type="checkbox" id="chkaccessinday"  onclick="enableday(this);"  ');
                         output.push('/>');
                         output.push('</td>');
                         output.push('<td  class="GridViewLabItemStyle">'); output.push('<input type="text"  disabled=true style="width:100px" onkeyup="txtRateVal(this);" id="txtduration" value="');
                         output.push(_Empdata[i].DurationInDay); output.push('"/>'); output.push('</td>');
                         output.push('<td class="GridViewLabItemStyle">'); output.push('<input type="checkbox" id="chkpdf" ');
                         if (_Empdata[i].ShowPdf == "1")
                             output.push('checked="checked"');
                         output.push('/>');
                         output.push('</td>');
                         output.push('<td  class="GridViewLabItemStyle">');
                         if ('<%=ReportID%>' != "2") {
                             output.push('<input type="checkbox" id="chkexcel"');
                             if (_Empdata[i].ShowExcel == "1")
                                 output.push('checked="checked"');
                             output.push('/>');
                         }
                         output.push('</td>');

                         output.push('<td id="chkbox" class="GridViewLabItemStyle"  Style="width:10px;"><input type="checkbox" id="chkactive" onclick="changeclr(this,' + parseInt(i + 1) + ');" ');
                         if (_Empdata[i].Active == "1")
                             output.push('checked="checked"');
                         output.push('/>');
                         output.push('</td>');
                         output.push('</tr>');
                     }
                     output = output.join('');
                     $("#tblcentrebody").html(output);
                 }
                 $modelUnBlockUI(function () { });
             });
        }
        function txtRateVal(id) {            
            id.value = id.value.replace(/[^0-9]/g, '');
        }
       
        function changeclr(ctrl, id) {
            if ($(ctrl).closest('tr').find("#chkactive").is(':checked'))
                $(ctrl).closest("#" + id + "").css('background-color', 'pink');
            else
                $(ctrl).closest("#" + id + "").css('background-color', 'white');
        }
        function $bindRoledata() {
            serverCall('ReportMaster_Access.aspx/getReportAccessDetails', { ReportID: '<%=ReportID%>', accessType: 'RoleId' }, function (response) {
                var $responseData = JSON.parse(response);
                $("#tblrolebody").html('');
                if ($responseData.status) {

                    var _Empdata = $responseData.data;
                    var output = [];
                    for (var i = 0; i < _Empdata.length; i++) {
                        output.push('<tr id="' + parseInt(i + 1) + '"');
                        if (_Empdata[i].Active == "1")
                            output.push('style="background-color:lightgreen"')
                        output.push('>');
                        output.push('<td   class="GridViewLabItemStyle"  style="width:100px;">');
                        output.push('<input type="hidden" id="hdnId" value="');
                        output.push(_Empdata[i].RoleID); output.push('"/>'); output.push(_Empdata[i].Name); output.push('</td>');
                        output.push('<td class="GridViewLabItemStyle">');
                        output.push('<input type="checkbox" id="chkaccessinday"  onclick="enableday(this);"  ');
                        output.push('/>');
                        output.push('</td>');
                        output.push('<td  class="GridViewLabItemStyle">'); output.push('<input type="text"  disabled=true style="width:100px" onkeyup="txtRateVal(this);" id="txtduration" value="');
                        output.push(_Empdata[i].DurationInDay); output.push('"/>'); output.push('</td>');
                        output.push('<td class="GridViewLabItemStyle">'); output.push('<input type="checkbox" id="chkpdf" ');
                        if (_Empdata[i].ShowPdf == "1")
                            output.push('checked="checked"');
                        output.push('/>');
                        output.push('</td>');
                        output.push('<td  class="GridViewLabItemStyle">');
                        if ('<%=ReportID%>' != "2") {
                            output.push('<input type="checkbox" id="chkexcel"');
                            if (_Empdata[i].ShowExcel == "1")
                                output.push('checked="checked"');
                            output.push('/>');
                        }
                        output.push('</td>');

                        output.push('<td id="chkbox" class="GridViewLabItemStyle"  Style="width:10px;"><input type="checkbox" id="chkactive"  onclick="changeclr(this,' + parseInt(i + 1) + ');" ');
                        if (_Empdata[i].Active == "1")
                            output.push('checked="checked"');
                        output.push('/>');
                        output.push('</td>');
                        output.push('</tr>');
                    }
                    output = output.join('');
                    $("#tblrolebody").html(output);
                }
                $modelUnBlockUI(function () { });
            });

        }                  
        $(function () {
            $bindCentredata();
            $bindRoledata();            
            $bindEmpdata();
        });
</script>

