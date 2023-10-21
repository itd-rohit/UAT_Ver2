<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="BulkReporting.aspx.cs" Inherits="Design_Lab_BulkReporting" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Purchase/EntryDate.ascx" TagName="EntryDate" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

         <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" />
     <%: Scripts.Render("~/bundles/confirmMinJS") %>
        <%: Scripts.Render("~/bundles/PostReportScript") %>
    <style type="text/css">
        .chosen-search {
            width: 340px;
        }
    </style>
    <style type="text/css">
        .savebutton {
            cursor: pointer;
            background-color: lightgreen;
            font-weight: bold;
            padding: 5px;
            border-radius: 5px;
            font-size: 15px;
        }

        .savebutton {
            cursor: pointer;
            background-color: lightgreen;
            font-weight: bold;
            padding: 5px;
            border-radius: 5px;
            font-size: 15px;
        }

        .resetbutton {
            cursor: pointer;
            background-color: lightcoral;
            font-weight: bold;
            padding: 5px;
            border-radius: 5px;
            font-size: 15px;
        }

        .searchbutton {
            cursor: pointer;
            background-color: blue;
            font-weight: bold;
            color: white;
            padding: 5px;
            border-radius: 5px;
            font-size: 15px;
        }

        .PrintButton {
            cursor: pointer;
            background-color: #00FFFF;
            font-weight: bold;
            color: black;
            padding: 5px;
            border-radius: 5px;
            font-size: 15px;
        }
    </style>
    <script type="text/javascript">
        function SaveData(_Status) {

            var TestID = "";
            $("#tb_Test tr").find("#chk").filter(':checked').each(function () {
                TestID += $(this).closest('tr').attr('id') + ',';
                $(this).closest('tr').css('background-color', '#90EE90');
            });
            if (TestID == "") {

                alert("Please Select Investigation");
                return;
            }
            debugger;
            var _ModDate = $("#<%=txtSampleDate1.ClientID %>").val();
            var _ModTime = $("#<%=txt_SampleTime.ClientID %>").val();
            $("#tb_Test tr").find("#chk").attr('checked', false);
            $.ajax({
                url: "BulkReporting.aspx/SaveData",
                data: '{TestID: "' + TestID + '",Status: "' + _Status + '",ModDate:"' + _ModDate + '",ModTime:"' + _ModTime + '"}', // parameter map 
                type: "POST",
                contentType: "application/json;charset=utf-8",
                timeout: 12000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                       
                        SearchData();
                        alert("Record Saved..!!");

                        return;
                    }
                    else if (result.d == "-1") {
                       
                        alert("Your Session Expired...Please Login Again");
                        return;
                    }
                    else {

                        alert("Please Try Again Later");
                        return;
                    }
                    $("#tb_TestDetail tr").find("#chk").attr('checked', false);


                },
                error: function (xhr, status) {

                    alert("Please Try Again Later");
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });

        }
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            $(document).keypress(function (e) {
                if (e.which == 13) {

                    SearchData('')

                }
            });
        });


        function SearchData(_Status) {
            try {

                $('#div_TestDetail').html('');

                var _CentreID = "";
                $('#<%=ddlCentreAccess.ClientID%> :selected').each(function (i, selected) {
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
                var isDeptSearch =0;
                if ($('#<%=chkisdept.ClientID%> ').is(':checked')) {
                    isDeptSearch=1;
                }
                $.ajax(
                   {
                       url: "BulkReporting.aspx/SearchData",
                       data: '{ Status:"' + _Status + '",LabNo: "' + $("#<%=txtLabNo.ClientID%>").val() + '",RegNo: "' + $("#<%=txtRegNo.ClientID%>").val() + '",PName: "' + $("#<%=txtPName.ClientID%>").val() + '",Mobile: "' + $("#<%=txtMobile.ClientID%>").val() + '",FromDate: "' + $("#<%=txtFromDate.ClientID%>").val() + '",ToDate: "' + $("#<%=txtToDate.ClientID%>").val() + '",CentreID: "' + _CentreID + '",PanelID: "' + _PanelID + '",DoctorID: "' + $("#<%=ddlDoctor.ClientID%>").val() + '",TimeFrm:"' + $("#<%=txtFromTime.ClientID%>").val() + '",TimeTo:"' + $("#<%=txtToTime.ClientID%>").val() + '",isDeptSearch:"' + isDeptSearch + '"}', // parameter map 
                       type: "POST",
                       contentType: "application/json;charset=utf-8",
                       timeout: 12000,
                       dataType: "json",
                       success: function (result) {
                          
                           if (result.d == "-1") {
                             
                               alert("Your Session Expired...Please Login Again");
                               return;
                           }
                           else if (result.d == "0") {
                             
                               alert("Please Try Again Later");
                               return;
                           }
                         
                           else if (result.d == "") {
                              
                               $('#div_TestDetail').html('No Record Found');
                               return;
                           }
                           else {
                               Info = eval('[' + result.d + ']');
                               var output = $('#tb_TestDetail').parseTemplate(Info);
                               $('#div_TestDetail').html(output);

                           }


                       },
                       error: function (xhr, status) {

                           $('#div_TestDetail').html('');
                           window.status = status + "\r\n" + xhr.responseText;
                       }
                   });
               }
               catch (e) {

                   alert(e);
               }
        }
        function PrintWorksheet(_Status) {
            try {

                var TestID = "";
                $("#tb_Test tr").find("#chkw").filter(':checked').each(function () {
                    TestID += $(this).closest('tr').attr('id') + ',';
                });
                if (TestID == "") {

                    alert("Please Select Investigation");
                    return;
                }

                var _CentreID = "";
                $('#<%=ddlCentreAccess.ClientID%> :selected').each(function (i, selected) {
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

                $.ajax(
                   {
                       url: "BulkReporting.aspx/PrintWorksheet",
                       data: '{ Status:"' + _Status + '",LabNo: "' + $("#<%=txtLabNo.ClientID%>").val() + '",RegNo: "' + $("#<%=txtRegNo.ClientID%>").val() + '",PName: "' + $("#<%=txtPName.ClientID%>").val() + '",Mobile: "' + $("#<%=txtMobile.ClientID%>").val() + '",FromDate: "' + $("#<%=txtFromDate.ClientID%>").val() + '",ToDate: "' + $("#<%=txtToDate.ClientID%>").val() + '",CentreID: "' + _CentreID + '",PanelID: "' + _PanelID + '",DoctorID: "' + $("#<%=ddlDoctor.ClientID%>").val() + '",TimeFrm:"' + $("#<%=txtFromTime.ClientID%>").val() + '",TimeTo:"' + $("#<%=txtToTime.ClientID%>").val() + '",TestID:"' + TestID  + '"}', // parameter map 
                       type: "POST",
                       contentType: "application/json;charset=utf-8",
                       timeout: 12000,
                       dataType: "json",
                       success: function (result) {

                           if (result.d == "1") {

                               window.open('../Common/Commonreport.aspx');
                               return;
                           }
                           else if (result.d == "0") {

                               alert("No Record Found !!");
                               return;
                           }

                          


                       },
                       error: function (xhr, status) {

                           $('#div_TestDetail').html('');
                           window.status = status + "\r\n" + xhr.responseText;
                       }
                   });
               }
               catch (e) {

                   alert(e);
               }
           }
        function $bindPanel() {
            $('#<%=ddlPanel.ClientID%> option').remove();
            jQuery('#<%=ddlPanel.ClientID%>').multipleSelect("refresh");
            $.ajax({
                url: "MachineResultEntry.aspx/GetPanelMaster",
                data: JSON.stringify({ centreid: 'ALL' }),
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",

                success: function (result) {
                    data = jQuery.parseJSON(result.d);
                 //   alert(result.d);
                    for (var a = 0; a <= data.length - 1; a++) {
                        jQuery('#<%=ddlPanel.ClientID%>').append($("<option></option>").val(data[a].panel_id).html(data[a].company_name));
                    }
                    jQuery('#<%=ddlPanel.ClientID%>').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                   
                },
                error: function (xhr, status) {
                    alert(xhr.responseText);
                   
                }
            });
            
        };
          
        function ckhall() {

            if ($('#chkheader').prop('checked') == true) {
                $('#tb_Test tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "header") {
                        $(this).closest("tr").find('#chk').prop('checked', true);
                    }
                });
            }
            else {
                $('#tb_Test tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "header") {
                        $(this).closest("tr").find('#chk').prop('checked', false);
                    }
                });
            }
}
function ckhallw() {
    if ($('#chkheaderw').prop('checked') == true) {
        $('#tb_Test tr').each(function () {
            var id = $(this).closest("tr").attr("id");
            if (id != "header") {
                $(this).closest("tr").find('#chkw').prop('checked', true);
            }
        });
    }
    else {
        $('#tb_Test tr').each(function () {
            var id = $(this).closest("tr").attr("id");
            if (id != "header") {
                $(this).closest("tr").find('#chkw').prop('checked', false);
            }
        });
    }
}
    </script>
    <script type="text/javascript">
        jQuery(function () {
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
           
            jQuery('[id*=<%=ddlCentreAccess.ClientID%>]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false, setSelects: true
            });
            jQuery('[id*=<%=ddlPanel.ClientID%>]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false, setSelects: true
            });




        });
    </script>
    <script id="tb_TestDetail" type="text/html"  >
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_Test" 
    style="border-collapse:collapse;">
		<tr> 
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">S. No</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Centre</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Reg Date/Time</th>  
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Receive Date/Time</th>  
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Lab No</th> 
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Barcode No</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">SRF ID</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">PName</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Age/Sex</th> 
             <th class="GridViewHeaderStyle" scope="col" style="width:100px;display:none;">Mobile</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Doctor</th>
             <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Panel</th>
             <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Dept</th>  
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Investigation</th>  
           <th class="GridViewHeaderStyle" scope="col" style="width:10px;"> 
			<input id="chkheader" type="checkbox"  onclick='ckhall();' /></th>
            <th class="GridViewHeaderStyle" scope="col" style="width:10px;">W
               <input id="chkheaderw" type="checkbox"  onclick='ckhallw();' />
			</th>
</tr>

<#       
 
 var dataLength1=Info.length;
 window.status="Total Records Found :"+ dataLength1;
 var objRow; 
        
        for(var j=0;j<dataLength1;j++)
        {

        objRow = Info[j]; 
        
            #>
<tr id="<#=objRow.Test_ID#>" style="background-color:<#=objRow.rowColor#>;">  
    <td class="GridViewLabItemStyle"><#=j+1#></td>
<td class="GridViewLabItemStyle"><#=objRow.Centre#></td>  
    <td class="GridViewLabItemStyle"><#=objRow.RegDate#></td> 
    <td class="GridViewLabItemStyle"><#=objRow.SampleReceiveDate#></td>
    <td class="GridViewLabItemStyle"><#=objRow.LabNo#></td>  
    <td class="GridViewLabItemStyle"><#=objRow.BarcodeNo#></td>     
    <td class="GridViewLabItemStyle"><#=objRow.srfno#></td>
    <td class="GridViewLabItemStyle"><#=objRow.PName#></td>
    <td class="GridViewLabItemStyle"><#=objRow.AgeGender#></td>
    <td class="GridViewLabItemStyle" style="display:none;"><#=objRow.Mobile#></td>
    <td class="GridViewLabItemStyle"><#=objRow.DocName#></td>     
    <td class="GridViewLabItemStyle"><#=objRow.PanelName#></td>
    <td class="GridViewLabItemStyle"><#=objRow.DeptName#></td>
    <td class="GridViewLabItemStyle"><#=objRow.Investigation#></td>   
   <td  class="GridViewLabItemStyle"> 
       <input type='checkbox' id='chk'  class="chk"/> 
   </td>
    <td  class="GridViewLabItemStyle"> 
       <input type='checkbox' id='chkw'  class="chk"/> 
   </td>
</tr>
  <#}#>              
</table>    
    </script>
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory" class="body_box_inventory" style="width: 97%">
        <div class="POuter_Box_Inventory" style="width: 99.6%;">
            <div class="content" style="text-align: center;">
                <b>Covid-19 Bulk Reporting</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="width: 99.6%;">
            <div class="row">
                 <div class="col-md-3">Lab No/SRF ID</div>
                <div class="col-md-3"><asp:TextBox ID="txtLabNo" runat="server" CssClass="ItDoseTextinputText" MaxLength="13"  /></div>
               
                <div class="col-md-3" ><asp:CheckBox ID="chkPanel" runat="server" Text="Panel :" TextAlign="left" onClick="$bindPanel();" /></div>
                <div class="col-md-3" ><asp:ListBox ID="ddlPanel" runat="server" class="ddlPanel" SelectionMode="Multiple" /></div>
                <div class="col-md-3">Patient Name </div>
                <div class="col-md-3"><asp:TextBox ID="txtPName" runat="server" CssClass="ItDoseTextinputText" MaxLength="20" /></div>
             <div class="col-md-3">Centre</div>
                <div class="col-md-3"><asp:ListBox ID="ddlCentreAccess" runat="server" Cclass="ddlCentreAccess" SelectionMode="Multiple" /></div>
                </div>

                  <div class="row">
                      <div class="col-md-3"><asp:CheckBox ID="chkisdept" runat="server" Text="is Dept :" TextAlign="left"  /></div>
                       <div class="col-md-3">From Date</div>
                       <div class="col-md-6"><asp:TextBox ID="txtFromDate" runat="server" CssClass="ItDoseTextinputText" MaxLength="20" Width="150px" />
                            <asp:Image ID="imgdtFrom" runat="server" ImageUrl="~/App_Images/ew_calendar.gif" />
                            <cc1:CalendarExtender runat="server" ID="ce_dtfrom"
                                TargetControlID="txtFromDate"
                                Format="dd-MMM-yyyy"
                                PopupButtonID="imgdtFrom" />
                            <asp:TextBox ID="txtFromTime" runat="server" Width="70px"></asp:TextBox>
                                 <cc1:MaskedEditExtender runat="server" ID="mee_txtFromTime" Mask="99:99:99" TargetControlID="txtFromTime"
                                                             AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                                                            
                                </cc1:MaskedEditExtender>
                                <cc1:MaskedEditValidator runat="server" ID="mev_txtFromTime"
                                        ControlExtender="mee_txtFromTime"
                                        ControlToValidate="txtFromTime"
                                        InvalidValueMessage="*"  >
                                 </cc1:MaskedEditValidator></div>
                       <div class="col-md-3"></div>
                       <div class="col-md-3">To Date</div>
                       <div class="col-md-6"><asp:TextBox ID="txtToDate" runat="server" CssClass="ItDoseTextinputText" MaxLength="20" Width="150px" />
                            <asp:Image ID="imgdtto" runat="server" ImageUrl="~/App_Images/ew_calendar.gif" />
                            <cc1:CalendarExtender runat="server" ID="CalendarExtender1"
                                TargetControlID="txtToDate"
                                Format="dd-MMM-yyyy"
                                PopupButtonID="imgdtto" />
                             <asp:TextBox ID="txtToTime" runat="server" Width="70px" ></asp:TextBox>
                                <cc1:MaskedEditExtender runat="server" ID="mee_txtToTime" Mask="99:99:99" TargetControlID="txtToTime"
                                        AcceptAMPM="false" AcceptNegative="None" MaskType="Time">                        
                                </cc1:MaskedEditExtender>
                                <cc1:MaskedEditValidator runat="server" ID="mev_txtToTime"
                                        ControlExtender="mee_txtToTime"  ControlToValidate="txtToTime"  
                                        InvalidValueMessage="*"  >
                                </cc1:MaskedEditValidator>
                            <asp:DropDownList ID="ddlDoctor" runat="server" CssClass="ItDoseTextinputText" MaxLength="20" Width="150px" Style="display: none;" />
                           <asp:TextBox ID="txtMobile" runat="server" CssClass="ItDoseTextinputText" MaxLength="12" Width="150px" Style="display: none;" />
                           <asp:TextBox ID="txtRegNo" runat="server" CssClass="ItDoseTextinputText" MaxLength="20" Width="150px" Style="display: none;" />
                       </div>
               
            </div>
        </div>

        <div class="POuter_Box_Inventory" style="width: 99.6%;">
            <div class="content" style="text-align: center; width: 100%;">

                <table width="100%" style="text-align: center;">
                    <tr>
                        <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; cursor: pointer; border-left: black thin solid; border-bottom: black thin solid; background-color: #CC99FF;"
                            onclick="SearchData('3')">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td>Sample Not Collected</td>
                         <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; cursor: pointer; border-left: black thin solid; border-bottom: black thin solid; background-color: #89f2f2;"
                            onclick="SearchData('6')">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td>Sample Collected</td>
                        <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; cursor: pointer; border-left: black thin solid; border-bottom: black thin solid; background-color: #B0C4DE;"
                            onclick="SearchData('2')">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td>Sample Rejected</td>
                        <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; cursor: pointer; border-left: black thin solid; border-bottom: black thin solid; background-color: White;"
                            onclick="SearchData('5')">&nbsp;&nbsp;&nbsp;&nbsp;</td>

                        <td>Result Not Done</td>
                        <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; cursor: pointer; border-left: black thin solid; border-bottom: black thin solid; background-color: #F781D8; display: none;"
                            onclick="SearchData('13')">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; cursor: pointer; border-left: black thin solid; border-bottom: black thin solid; background-color: Pink;"
                            onclick="SearchData('4')">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td>Result Done</td>
                        <td style="width: 25px; border-right: black thin solid; border-top: black thin solid; cursor: pointer; border-left: black thin solid; border-bottom: black thin solid; background-color: #FFFF00;"
                            onclick="SearchData('8')">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td>Hold</td>

                    </tr>
                </table>

            </div>

        </div>
        <div class="POuter_Box_Inventory" style="width: 99.6%;">
            <div class="content" style="text-align: center; width: 100%;">
                <input id="btnSearch" type="button" value="Search" class="searchbutton" style="width: 134px;" onclick="SearchData('');" />
                <asp:TextBox ID="txtSampleDate1" CssClass="ItDoseTextinputText" runat="server" ReadOnly="true" Width="100px"></asp:TextBox>
                <cc1:CalendarExtender ID="ce_sampleDate2" runat="server" Format="dd-MMM-yyyy" PopupButtonID="imgSampleDate1" TargetControlID="txtSampleDate1" />
                <asp:Image ID="imgSampleDate1" runat="server" ImageUrl="~/App_Images/ew_calendar.gif" />


                <asp:TextBox ID="txt_SampleTime" runat="server" Width="70px"></asp:TextBox>
                <cc1:MaskedEditExtender runat="server" ID="mee_txt_SampleTime" Mask="99:99:99" TargetControlID="txt_SampleTime"
                    AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                </cc1:MaskedEditExtender>
                <cc1:MaskedEditValidator runat="server" ID="mev_txt_SampleTime"
                    ControlExtender="mee_txt_SampleTime"
                    ControlToValidate="txt_SampleTime"
                    InvalidValueMessage="*">
                </cc1:MaskedEditValidator>
                <input id="btnSave" type="button" value="Bulk Collection" class="savebutton" style="width: 100px;" onclick="SaveData('1');" />
                <input id="Button4" type="button" value="Bulk Receive" class="savebutton" style="width: 100px;" onclick="SaveData('2');" />
                <input id="Button5" type="button" value="Bulk Reject" class="savebutton" style="width: 100px;" onclick="SaveData('6');" />
                <input id="Button1" type="button" value="Save Negative" class="savebutton" style="width: 100px;" onclick="SaveData('3');" />
                <input id="Button2" type="button" value="Hold" class="savebutton" style="width: 100px;" onclick="SaveData('4');" />
                <input id="Button3" type="button" value="Approved Negative" class="savebutton" style="width: 120px;" onclick="SaveData('5');" />
                <input id="Button6" type="button" value="Worksheet" class="savebutton" style="width: 100px;" onclick="PrintWorksheet('');" />
            </div>
        </div>
        <div class="Outer_Box_Inventory" style="width: 99.6%; text-align: center;">
            <div class="Purchaseheader">Patient Detail(s) Found</div>
            <div id="div_TestDetail" style="max-height: 400px; overflow: auto;"></div>
        </div>

    </div>

</asp:Content>

