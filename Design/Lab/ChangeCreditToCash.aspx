<%@ Page Title="" Language="C#"  AutoEventWireup="true" CodeFile="ChangeCreditToCash.aspx.cs" Inherits="Design_Lab_ChangeCreditToCash" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title></title>
       
    <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/App_Style/css" />
<webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/jquery-ui.css" /> 
     <webopt:BundleReference ID="BundleReference5" runat="server" Path="~/App_Style/chosen.css" />
<link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 
    <link href="../../App_Style/toastrsample.css" rel="stylesheet" /> 
    </head>
    <body >
    
    <form id="form1" runat="server">
    <style type="text/css">
        .chosen-search {
            width: 230px;
        }
    </style>
    <Ajax:ScriptManager ID="ScriptManager2" runat="server" LoadScriptsBeforeUI="true"   EnablePageMethods="true">  
<Scripts>
     <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
     <asp:ScriptReference Path="~/Scripts/jquery.multiple.select.js" />
     <asp:ScriptReference Path="~/Scripts/chosen.jquery.js" />
     <asp:ScriptReference Path="~/Scripts/Common.js" />
    <asp:ScriptReference Path="~/Scripts/toastr.min.js" />

</Scripts>
</Ajax:ScriptManager>
    <script type="text/javascript">

        $(document).ready(function () {
            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': { allow_single_deselect: true },
                '.chosen-select-no-single': { disable_search_threshold: 10 },
                '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chosen-select-width': { width: "60%" }
            }

            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
        });
    </script>

    <div id="Pbody_box_inventory">
        
        <div class="POuter_Box_Inventory">
            <div class="row" style="text-align: center;">
                <div class="col-md-24">
                    <asp:Label ID="llheader" runat="server" Text="Panel Change" Font-Size="16px" Font-Bold="true" CssClass="PatientLabel"></asp:Label>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Search Option &nbsp;</div>
            <div class="row">
                
                <div class="col-md-8"></div>
                <div class="col-md-3">
                    <b>Visit No.  :</b>
                </div>
                <div class="col-md-5">
                    <input type="text" id="labno" maxlength="15"/>
                </div>
                <div class="col-md-5">
                    <input type="button" value="Search" onclick="Getrecieptdata()"/>
                </div>
            </div>
			<div class="row">
                    <div class="col-md-24">
                        <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                    </div>
                </div>
            </div>
        <div class="POuter_Box_Inventory  alreadyPay" style="display:none;text-align:center;color:red;">
            <h2>Sorry ! You can't change panel because patient has already paid</h2>
        </div>
        <div class="POuter_Box_Inventory details" style="display:none">
             <div class="Purchaseheader">Change Option&nbsp;</div>
            <div class="row">
                <div class="col-md-3">
                    Visit No.
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtVisitNo" readonly="readonly"/>
                </div>
                <div class="col-md-3">
                    Patient Name
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtPNAme" readonly="readonly"/>
                </div>
                <div class="col-md-3">
                    UHID
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtUHID" readonly="readonly"/>
                </div>
                </div>
            <div class="row">
                <div class="col-md-3">
                    Age
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtAge" readonly="readonly"/>
                </div>
                <div class="col-md-3">
                    Reg. Date & Time
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtDate" readonly="readonly"/>
                </div>
                <div class="col-md-3">
                    Gender
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtGender" readonly="readonly"/>
                </div>
            </div>
            <div class="row" style="border-top:1px solid #cfcfcf">
                <div class="col-md-8">
                    <table style="width:100%">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle">
                                    Test Name
                                </th>
                                <th class="GridViewHeaderStyle">
                                    Rate
                                </th>
                                <th class="GridViewHeaderStyle">
                                    Status
                                </th>
                            </tr>
                        </thead>
                        <tbody id="testtbl">

                        </tbody>
                    </table>
                </div>
                <div class="col-md-8">
                    <div class="row">
                        <div class="col-md-9">
                            Current Panel
                        </div>
                        <div class="col-md-15">
                            <input type="text" id="txtPanelName" readonly="readonly" />
                        </div>
                    </div><div class="row">
                        <div class="col-md-9">
                            Current Payment Type
                        </div>
                        <div class="col-md-15">
                            <input type="text" id="txtPaymentType" readonly="readonly" />
                        </div>
                    </div>
                </div>
                
                <div class="col-md-8">
                    <div class="row">
                        <div class="col-md-9">
                            Change Panel
                        </div>
                        <div class="col-md-15">
                            <select id="ddlPanel"></select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-24" style="text-align:center">
                            <input type="button" onclick="UpdatePaymentMode()" value="Update" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        var OldPanelID = "";
        function Getrecieptdata() {
            OldPanelID = "";

            if ($("#labno").val().trim() == "")
            {
                alert("Please enter Visit No. !");
                return;
            }
            $(".details").hide();
            $(".alreadyPay").hide();
            $.ajax({
                url: "ChangeCreditToCash.aspx/Getrecieptdata",
                type: "POST",
                dataType: "json",
                data: JSON.stringify({ search: $("#labno").val().trim()}),
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    if (response.d == "-3") {
                        alert("Time is expired . You cannot Change Panel...!");
                        return false;
                    }
                   else if (response.d == "1")
                    {
                        alert("No Data Found");
                    }
                    else if (response.d == "-1") {
                        alert( "error !");
                    }
                    else if (response.d == "2") {
                        $(".alreadyPay").show();
                    }
                    else {
                        var data = JSON.parse(response.d);
						if (data.Details[0].BillTimeDiff > 10080 && '<%=Session["RoleID"]%>' == '2') {
                            $("#lblMsg").text('You can Edit Panel within 7 Days of Billing...!');
                            //$('.savebutton,.resetbutton').hide();
                            return false;
                        }
						else {
                        $("#txtVisitNo").val(data.Details[0].LedgerTransactionNo);
                        $("#txtPNAme").val(data.Details[0].PName);
                        $("#txtUHID").val(data.Details[0].Patient_ID);
                        $("#txtAge").val(data.Details[0].Age);
                        $("#txtGender").val(data.Details[0].Gender);
                        $("#txtDate").val(data.Details[0].Date);
                        $("#txtPanelName").val(data.Details[0].Company_Name);
                        $("#txtPaymentType").val((data.Details[0].IsCredit=="1")?'In Credit':'Payment Pending');
                        
                        OldPanelID = data.Details[0].Panel_ID;
                        var Html = "";
                        data.Tests.forEach(function(item,index){
                            Html += "<tr>";
                            Html += "<td class='GridViewLabItemStyle'>"; Html += item.ItemName; Html += "</td>";
                            Html += "<td class='GridViewLabItemStyle' Style='text-align:right'>"; Html += item.Rate; Html += "</td>";
                            Html += "<td class='GridViewLabItemStyle'>"; Html += item.IsActive; Html += "</td>";
                            Html += "</tr>";
                        });
                        $("#testtbl").html(Html);


                        $(".details").show();
						}
                    }
                },
                error: function () {
                    alert( "error !");
                }
            });
        }

        function BindPanel() {
            $("#ddlPanel").html("");
            $("#ddlPanel").empty();
            $.ajax({
                url: "ChangeCreditToCash.aspx/GetPanelList",
                type: "post",
                dataType: "json",
                data: {},
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    if (response.d != "1" && response.d != "-1") {
                        var data = JSON.parse(response.d);
                        data.forEach(function (item) {
                            if(item.Company_Name != null)
                            $("#ddlPanel").append($("<option></option>").text(item.Company_Name).val(item.Panel_ID));
                        });
                    } else {
                        alert("No panel Found");
                    }
                },
                error: function () {
                    alert( "error");
                }
            });
        }

        BindPanel();
        function UpdatePaymentMode() {
            console.log(OldPanelID);
            var code = $("#ddlPanel").val().trim().split('#');
            var NewPanelID = code[0];
            var ReffCode = code[1];
            var LabNo = $("#txtVisitNo").val().trim();
            var PanelID_MRP = code[3];
            if (LabNo.trim() == "" || NewPanelID.trim() == "" || (OldPanelID == ""||OldPanelID==0)) {
                alert("Please Check All Valid Details !!");
                return;
            }
            serverCall('ChangeCreditToCash.aspx/UpdatePaymentMode', { LabNo: LabNo, OldPanel: OldPanelID, NewPanel: NewPanelID, RefferanceCode: ReffCode, type: code[2], PanelID_MRP: PanelID_MRP }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast('Success', $responseData.response);
                }
                else {
                    toast('Error', $responseData.response);
                }
            });
            
        }
    </script>
</form></body></html>

