<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ReportMaster.aspx.cs" Inherits="Design_Master_ReportMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">  
        <webopt:BundleReference ID="BundleReference7" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
    
      <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox.pack.js"></script>     
   
    <div id="Pbody_box_inventory">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-24">
                    <b>Report Access Master<br />
                    </b>                    
                </div>
            </div>

        </div>

        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-4">
                    <label class="pull-left">Report Type </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:TextBox ID="txtreporttype" CssClass="requiredField" runat="server"></asp:TextBox>
                    <input type="hidden" value="" id="hfReportID" />
                </div>
                <div class="col-md-4">
                    <label class="pull-left">Report Name </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                   <asp:TextBox ID="txtreportname" CssClass="requiredField" runat="server"></asp:TextBox>
                </div>
               
            </div>           
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <input type="button" id="btnSave" class="ItDoseButton" value="Save" onclick="$saveDetails();" />
            <input type="button" id="btnClear" class="ItDoseButton" value="Clear" onclick="$Clear();" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: left;">
            <div class="Purchaseheader">
                Report Details
            </div>
            <div id="PatientLabSearchOutput" style="max-height: 350px; overflow: auto;">
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $(function () {
            $SearchDetails();
        });
        function DocumentData() {
            var obj = new Object();
            obj.ReportID = $('[id$=hfReportID]').val();
            obj.ReportType = $('[id$=txtreporttype]').val();
            obj.ReportName = $('[id$=txtreportname]').val();
            return obj;
        }
        function Validate() {
            if ($("#<%=txtreporttype.ClientID%>").val() == "") {
                toast("Error", "Please Enter Report Type", "");
                return false;
            }
            if ($("#<%=txtreportname.ClientID%>").val() == "") {
                 toast("Error", "Please Enter Report Name", "");
                 return false;
             }                       
             return true;
         }
        var $saveDetails = function () {
            if (!Validate()) {
                return false;
            }
            var _DocDetails = DocumentData();
            serverCall('ReportMaster.aspx/SaveReportDetails', { DocDetails: _DocDetails }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast("Success", "Record Saved Successfully", "");
                    $SearchDetails(function () { });
                    $Clear();                                                         
                }
                else {
                    toast("Error", $responseData.ErrorMsg, "");
                }               
            });

        }
        var $Clear = function () {
            $('[id$=txtreporttype]').val('');
            $('[id$=txtreportname]').val('');
            $('[id$=hfReportID]').val('');
            $('#btnSave').val('Save');
        }
        var $SearchDetails = function () {
            serverCall('ReportMaster.aspx/GetReportDetails', {  }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    PatientData = $responseData.data;
                    var mydata = [];
                    mydata.push('<tr>');
                    mydata.push('<tr id="Header">');
                    mydata.push('<th class="GridViewHeaderStyle" scope="col" style="width:45px;">S.No.</th>');
                    
                    mydata.push('<th class="GridViewHeaderStyle" scope="col" style="width:200px;">Report Type</th>');
                    mydata.push('<th class="GridViewHeaderStyle" scope="col" style="width:200px;">Report Name</th>');
                    mydata.push('<th class="GridViewHeaderStyle" scope="col" style="width:45px;">ReportID</th>');
                    mydata.push('<th class="GridViewHeaderStyle" scope="col" style="width:200px;">Entry By</th>');                   
                    mydata.push('<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Edit</th>');                                        
                    mydata.push('<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Report Access</th>');
                    mydata.push('</tr>');                  
                    for (var j = 0; j < PatientData.length; j++) {
                        var output = [];
                        output.push('<tr id="tr_');
                        output.push((parseInt(j) + 1));
                        output.push('">');
                        output.push('<td class="GridViewLabItemStyle">');
                        output.push((parseInt(j) + 1));
                        output.push('<input type="hidden" id="hdnId" value="');
                        output.push(PatientData[j].ReportID);
                        output.push('"/>');                       
                        output.push('</td>');                      
                        output.push('<td id="tdReportType"  class="GridViewLabItemStyle"  style="width:200px;">');
                        output.push(PatientData[j].ReportType); output.push('</td>');                       
                        output.push('<td id="tdReportName" class="GridViewLabItemStyle" Style="width:200px">');
                        output.push(PatientData[j].ReportName); output.push('</td>');
                        output.push('<td class="GridViewLabItemStyle">');
                        output.push(PatientData[j].ReportID); output.push('</td>');
                        output.push('<td  id="tdEntryBy" class="GridViewLabItemStyle" Style="width:200px;">');
                        output.push(PatientData[j].EntryByName); output.push('</td>');                       
                        output.push('<td class="GridViewLabItemStyle"  Style="width:100px; text-align:center" ><img style="cursor: pointer;vertical-align: middle;" alt="edit" src="../../App_Images/edit.png" onclick="EditDetails(this)" /> </td>');                                               

                        output.push('<td id="chkbox"class="GridViewLabItemStyle"  Style="width:100px;"><img style="cursor: pointer;width: 18px;vertical-align: middle;" alt="upload pdf" src="../../App_Images/report_check.png"  onclick="openAccess(this)"   /> </td>');
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
        function EditDetails(ctr) {
            var $row = $(ctr).closest('tr');
            $("#hfReportID").val($row.find("#hdnId").val());
            $("#<%=txtreportname.ClientID%>").val($row.find("#tdReportName").html());
            $("#<%=txtreporttype.ClientID%>").val($row.find("#tdReportType").html());
            $("#btnSave").val('Update');
        }
        function openAccess(ctr) {
            var ReportID = $(ctr).closest('tr').find("#hdnId").val();
            var $Reporttype = "".concat($(ctr).closest('tr').find("#tdReportType").html(), '(', $(ctr).closest('tr').find("#tdReportName").html(), ')');
            openmypopup("ReportMaster_Access.aspx?ReportID=" + ReportID + "&ReportName=" + $Reporttype);
        }
        function openmypopup(href) {
            var width = '1120px';
            $.fancybox({
                maxWidth: 990,
                maxHeight: 830,
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

