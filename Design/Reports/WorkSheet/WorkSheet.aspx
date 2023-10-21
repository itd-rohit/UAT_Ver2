<%@ Page Language="C#" AutoEventWireup="true" CodeFile="WorkSheet.aspx.cs" Inherits="Design_Lab_WorkSheet"  %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title></title>
       
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
<webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" /> 
<link href="../../../App_Style/multiple-select.css" rel="stylesheet" /> 

    </head>
    <body >
    
         <form id="form1" runat="server">
               <Ajax:ScriptManager ID="ScriptManager2" runat="server" LoadScriptsBeforeUI="true"   EnablePageMethods="true">  
<Scripts>
     <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
     <asp:ScriptReference Path="~/Scripts/jquery.multiple.select.js" />
     <asp:ScriptReference Path="~/Scripts/chosen.jquery.js" />
     <asp:ScriptReference Path="~/Scripts/Common.js" />
    <asp:ScriptReference Path="~/Scripts/toastr.min.js" />
    <asp:ScriptReference Path="~/Scripts/PostReportScript.js" />
</Scripts>
                    <Services>
  <Ajax:ServiceReference Path="../../Lab/Services/PatientLabSearch.asmx" />
 
  </Services>
</Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
           
                <b>Worksheet LabObservation Wise</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Search Option</div>
          <div class="row">
                 <div class="col-md-4"><label class="pull-right">From Date :</label> </div>
                    <div class="col-md-2">   <asp:TextBox ID="dtFrom" runat="server" ></asp:TextBox>
                  <cc1:CalendarExtender runat="server" ID="ce_dtfrom" TargetControlID="dtFrom" Format="dd-MMM-yyyy" /></div>
                        <div class="col-md-2">  
                         <asp:TextBox ID="txtFromTime" runat="server"></asp:TextBox>
                        <cc1:MaskedEditExtender runat="server" ID="mee_txtFromTime" Mask="99:99:99" TargetControlID="txtFromTime"
                         AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                        
                        </cc1:MaskedEditExtender>
                    </div>
                    <div class="col-md-4"><label class="pull-right">To Date :</label> </div>
                    <div class="col-md-2">   <asp:TextBox ID="ToDate" runat="server" Visible="false" ></asp:TextBox>
                   
                       <asp:TextBox ID="dtTo" runat="server"  ></asp:TextBox>
                    <cc1:CalendarExtender runat="server" ID="ce_dtTo" TargetControlID="dtTo" Format="dd-MMM-yyyy" />
                      </div> <div class="col-md-2">  
                        <asp:TextBox ID="txtToTime" runat="server"></asp:TextBox>
                        <cc1:MaskedEditExtender runat="server" ID="mee_txtToTime" Mask="99:99:99" TargetControlID="txtToTime"
                         AcceptAMPM="false" AcceptNegative="None" MaskType="Time"> </cc1:MaskedEditExtender>
                <cc1:MaskedEditValidator runat="server" ID="mev_txtToTime"
                ControlExtender="mee_txtToTime"  ControlToValidate="txtToTime"  
                InvalidValueMessage="*"  ></cc1:MaskedEditValidator></div>
              <div class="col-md-4"><label class="pull-right">Patient Name :</label> </div>
               <div class="col-md-4">  <asp:TextBox ID="txtPName" runat="server"/></div>
            
          </div>
             <div class="row">
              <div class="col-md-4"><label class="pull-right">Lab No. :</label> </div>
                 <div class="col-md-4">  <asp:TextBox ID="txtLabNo" runat="server"/></div>
                 <div class="col-md-4"><label class="pull-right">Sin No.:</label> </div>
                 <div class="col-md-4"> <asp:TextBox ID="txtSinNo" runat="server"/></div>
                 <div class="col-md-4"><label class="pull-right">Search By Date :</label> </div>
                 <div class="col-md-4"><asp:DropDownList ID="ddlSearchByDate"  runat="server">
                                    <asp:ListItem Value="Registeration Date">Registration Date</asp:ListItem>
                                    <asp:ListItem Value="Sample Receiving Date" Selected="True">Sample Receiving Date</asp:ListItem>
                                    <asp:ListItem Value="Approved Date">Approved Date</asp:ListItem>
                                    <asp:ListItem Value="Sample Collection Date">Sample Collection Date</asp:ListItem>
                                </asp:DropDownList></div>
              
             </div>
          
             <div class="row">
              <div class="col-md-4"><label class="pull-right">Phone No. :</label> </div>
                  <div class="col-md-4"><asp:TextBox ID="txtPhone" runat="server" ></asp:TextBox>
                              <cc1:FilteredTextBoxExtender ID="ftbPhone" runat="server" TargetControlID="txtPhone"  FilterType="Numbers"></cc1:FilteredTextBoxExtender></div>
                  <div class="col-md-4"><label class="pull-right">Mobile No.:</label> </div>
                  <div class="col-md-4"><asp:TextBox ID="txtMobile" runat="server" ></asp:TextBox>
                              <cc1:FilteredTextBoxExtender ID="ftbMobile" runat="server" TargetControlID="txtMobile"  FilterType="Numbers"></cc1:FilteredTextBoxExtender></div>
            
                         <div class="col-md-4"><label class="pull-right">UHID No. :</label> </div>
                    <div class="col-md-4"> <asp:TextBox ID="txtCRNo" runat="server" /></div>
                 </div>
            <div class="row">
              <div class="col-md-4"><label class="pull-right">Panel :</label> </div>
                 <div class="col-md-4"><asp:DropDownList ID="ddlPanel" runat="server"></asp:DropDownList></div>
                <div class="col-md-4"><label class="pull-right">Status :</label> </div>
                   <div class="col-md-4"> <asp:DropDownList ID="ddlStatus" runat="server">
                            
                                    <asp:ListItem></asp:ListItem>
                                    <asp:ListItem Value="Approved">Approved</asp:ListItem>
                                    <asp:ListItem Value="Not Approved">Not Approved</asp:ListItem>
                                    <asp:ListItem Value="Result Done">Result Done</asp:ListItem>
                                    <asp:ListItem Value="Incomplete">Incomplete</asp:ListItem>
                                    <asp:ListItem Selected="True" Value="Result Not Done">Result Not Done</asp:ListItem>
                                    <asp:ListItem Value="Forward">Forward</asp:ListItem>
                                    <asp:ListItem Value="Hold">Hold</asp:ListItem>
                                    <asp:ListItem Value="Pending">Pending</asp:ListItem>    
                                                                
                            </asp:DropDownList></div>
                 
                 <div class="col-md-4"><label class="pull-right">Patient Type :</label> </div>
                 <div class="col-md-4"><asp:DropDownList ID="ddlPatientType" runat="server">
    <asp:ListItem Selected="True" Value="0">All</asp:ListItem>
    <asp:ListItem Value="1">Urgent</asp:ListItem>
</asp:DropDownList></div>
                </div>
            <div class="row">
              <div class="col-md-4"><label class="pull-right">Center:</label></div>
              <div class="col-md-4"><asp:ListBox ID="chlCentre" runat="server"  ClientIDMode="Static"  CssClass="multiple" SelectionMode="Multiple"></asp:ListBox> </div>
           
              <div class="col-md-4"><label class="pull-right">Department :</label></div>
               <div class="col-md-4"><asp:ListBox ID="ddlDepartment" CssClass="multiselect"  ClientIDMode="Static" SelectionMode="Multiple"  runat="server" onchange="BindInvestigations()"></asp:ListBox></div>
               <div class="col-md-4"><label class="pull-right">Investigation :</label></div>
               <div class="col-md-4"><asp:ListBox ID="ddlInvestigations" CssClass="multiple" SelectionMode="Multiple" ClientIDMode="Static" runat="server"></asp:ListBox></div>
              </div> 
             <div class="row">
              <div class="col-md-4"><label class="pull-right">Machine :</label> </div>
                   <div class="col-md-4"> <asp:DropDownList ID="ddlmachine" runat ="server" /></div>
                  <div class="col-md-4"> </div>
                   <div class="col-md-8"> <input id="ChkisUrgent" type="checkbox" />
                            Search Urgent Investigations</div>
                  
                   <div class="col-md-4"><input id="chkrerun" type="checkbox" />
                            Search Rerun TestOnly</div>
                 
                 </div>
            
              

                
              
              
           
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
           
                 
                     <input id="btnSearch" type="button" value="Search"  class="ItDoseButton" onclick="PatientWorkSheet('0')" />
                &nbsp; &nbsp;
                <input type="button" id="WRKbtn" class="ItDoseButton" value="WorkSheet"  /></div>
             <div class="POuter_Box_Inventory" style="text-align: center;">
             <table  style="width:100%;border-collapse:collapse">
                        <tr>
                            <td>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                            <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #CC99FF;" onclick="PatientWorkSheet('1')">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                                New</td> 
<td style="width: 25px; border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: bisque;" onclick="PatientWorkSheet('2')">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                                Sample Collected</td>
  <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: White;" onclick="PatientWorkSheet('3')" >
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                                Department Receive</td>

                               <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #F781D8;"  onclick="PatientWorkSheet('5')">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                               ReRun</td> 
                                       
                            <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #FFC0CB;" onclick="PatientWorkSheet('7')">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                               Tested</td>
                                 <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #90EE90;"  onclick="PatientWorkSheet('8')">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                                Approved</td>
                                  <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:#00FFFF;"  onclick="PatientWorkSheet('9')">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                                 Printed</td>
                                <td style="width: 25px; border-right: black thin solid; border-top: black thin solid;cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #FFFF00;"  onclick="PatientWorkSheet('10')">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                               Hold</td>
                            
                                   <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; cursor:pointer;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #44A3AA;" onclick="PatientWorkSheet('13')">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                              Dispatched</td>
                        </tr>
                    </table>
                    
               
            </div>
        
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Search Result
            </div>
           <div id="PatientLabSearchOutput" style="max-height:350px; overflow-y:auto; overflow-x:hidden;">
            
                
            </div>
    </div>
    <iframe id="iframePatient" name="iframePatient" src="" style="position: fixed; top: 0px;
        left: 0px; background-color: #FFFFFF; display: none;" frameborder="0" enableviewstate="true">
    </iframe>
    
    <script id="tb_PatientLabSearch" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch" 
    style="width:100%;border-collapse:collapse;">
		<tr>
			<th class="GridViewHeaderStyle" scope="col" style="width:30px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">UHID No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">Lab No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:160px;">Patient Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">Accession No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:110px;">Age/Sex</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:270px;">Investigation</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">Date</th>
			<th class="GridViewHeaderStyle" scope="col"><input type="checkbox" id="chkAll" onClick="checkAll()" /></th>
	
</tr>
       <#
       
              var dataLength=PatientData.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {

        objRow = PatientData[j];

         
            #>
                    <tr id="tr_<#=objRow.Test_ID#>" style="background-color:<#=objRow.rowColor#>;">
<td class="GridViewLabItemStyle"><#=j+1#></td>
<td class="GridViewLabItemStyle"><#=objRow.Patient_ID#></td>
<td class="GridViewLabItemStyle"><#=objRow.LedgerTransactionNo#></td>
<td class="GridViewLabItemStyle"><#=objRow.pname#></td>
<td class="GridViewLabItemStyle"><#=objRow.CardNo#></td>
<td class="GridViewLabItemStyle"><#=objRow.age#></td>
<td class="GridViewLabItemStyle"><#=objRow.ObservationName#></td>
<td class="GridViewLabItemStyle"><#=objRow.InDate#></td>
<td class="GridViewLabItemStyle" style="text-align:center"><input type="checkbox" id=<#=objRow.LedgerTransactionNo#>,<#=objRow.Patient_ID#>,<#=objRow.ReportType#>,<#=objRow.Test_ID#>,<#=objRow.Dept#> />
</td>



</tr>

            <#}#>

     </table>    
    </script>
    <script type="text/javascript" >
        $(function () {
            $("#WRKbtn").click(sveCollctn);
            $('[id$=chlCentre]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id$=ddlDepartment]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id$=ddlInvestigations]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });

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
            jQuery('#chlCentre').trigger('chosen:updated');
            jQuery('#ddlInvestigations').trigger('chosen:updated');
            jQuery('#ddlDepartment').trigger('chosen:updated');
            BindInvestigations();
        });
        function sveCollctn() {
            var totals;
            var rowundrGrid;
            var idofchkbx;
            var cntTotalRow = '';
            var ConcatVal = '';
            var c = document.getElementById("tb_grdLabSearch");
            cntTotalRow = c.rows.length;
            for (var i = 1; i <= cntTotalRow - 1; i++) {
                var cellPivot = c.rows[i].cells[8]

                var obj = ((c.rows[i].cells[8]).firstChild.checked);
                if (obj == true) {
                    idofchkbx = cellPivot.firstChild.id;
                    ConcatVal += idofchkbx + '|';
                }

            }
            var abcd = ConcatVal;
            if (ConcatVal == "") {
                alert('Please Select Item');
                return;
            }
            PatientLabSearch.sendData(ConcatVal, OnComplete, OnError, OnTimeOut);
            function OnComplete(arg) {
                var fromdate = $("#<%=dtFrom.ClientID%>").val() + ' ' + $("#<%=txtFromTime.ClientID%>").val();
                var todate = $("#<%=dtTo.ClientID%>").val() + ' ' + $("#<%=txtToTime.ClientID%>").val();
                var rerun = $("#chkrerun").is(':checked') ? 1 : 0;
                window.open('patientLabSearchWorksheetsReport.aspx?CentreID=' + $('#chlCentre').multipleSelect("getSelects").join() + '&FromDate=' + fromdate + '&ToDate=' + todate + '&Patient_Details_ID=&macid=' + $('#<%=ddlmachine.ClientID%>').val() + '&rerun=' + rerun);
        }
        function OnTimeOut(arg)
        { }
        function OnError(arg)
        { }
    }
    function checkAll() {
        var table = document.getElementById("tb_grdLabSearch");
        var Count = table.rows.length;
        for (var i = 1; i <= Count - 1; i++) {
            var obj = ((table.rows[i].cells[8]).firstChild.checked);

            if (obj == true) {
                ((table.rows[i].cells[8]).firstChild.checked = false)
            }
            else {
                ((table.rows[i].cells[8]).firstChild.checked = true)
            }
        }
    }
    function BindInvestigations() {

        $('[id$=ddlInvestigations]').find('option').remove();
        var DeptId = $('[id$=ddlDepartment]').val().toString();

        if (DeptId != "0") {
            var $ddlInv = $('#ddlInvestigations');
            $("#ddlInvestigations option").remove();
            serverCall('WorkSheet.aspx/BindInvestigations', { DeptId: DeptId }, function (response) {
                var data = $.parseJSON(response);
                if (data.length > 0) {
                    var html = "<option value=0>--Select--</option>";
                    for (var i = 0; i < data.length; i++) {
                        jQuery('#ddlInvestigations').append($("<option></option>").val(data[i].ItemId).html(data[i].TypeName));
                    }
                }
                $('[id$=ddlInvestigations]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
            });
        } else {
            $('[id$=ddlInvestigations]').find('option').remove();

        }
    }
    </script>
    <script type="text/javascript">
       
        
        var PatientData = "";
        function PatientWorkSheet(colorcode) {
            var symbol = "";
            debugger;
            var isUrgent = $("#ChkisUrgent").is(':checked') ? 1 : 0;
            var rerun = $("#chkrerun").is(':checked') ? 1 : 0;
            $("#PatientLabSearchOutput").empty();
            serverCall('../../Lab/Services/PatientLabSearch.asmx/Search_WorkSheet', { LabNo: $("#<%=txtLabNo.ClientID %>").val(), RegNo: $("#<%=txtCRNo.ClientID %>").val(), PName: $("#<%=txtPName.ClientID %>").val(), CentreID: $('#chlCentre').multipleSelect("getSelects").join(), dtFrom: $("#<%=dtFrom.ClientID %>").val(), dtTo: $("#<%=dtTo.ClientID %>").val(), SearchByDate: $("#<%=ddlSearchByDate.ClientID %>").val(), Dept: $('#ddlDepartment').multipleSelect("getSelects").join(), Status: $("#<%=ddlStatus.ClientID %>").val(), PhoneNo: $("#<%=txtPhone.ClientID %>").val(), Mobile: $("#<%=txtMobile.ClientID %>").val(), refrdby: "", Ptype: $("#<%=ddlPatientType.ClientID%>").val(), TimeFrm: $("#<%=txtFromTime.ClientID%>").val(), TimeTo: $("#<%=txtToTime.ClientID%>").val(), FromLabNo: "", ToLabNo: "", PanelID: $("#<%=ddlPanel.ClientID %>").val(), CardNoFrom: "", CardNoTo: "", InvestigationID: $('#ddlInvestigations').multipleSelect("getSelects").join(), isUrgent: isUrgent, slidenumber: "", macid: $('#<%=ddlmachine.ClientID%>').val(), rerun: rerun, colorCode: colorcode, SinNo: $('#<%=txtSinNo.ClientID%>').val() }, function (response) {

                PatientData = JSON.parse(response);
                var output = $('#tb_PatientLabSearch').parseTemplate(PatientData);
                $('#PatientLabSearchOutput').html(output);
            });

        };
                  </script>
</form>
</body>
</html>

