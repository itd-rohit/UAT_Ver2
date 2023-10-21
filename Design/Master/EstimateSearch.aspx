<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="EstimateSearch.aspx.cs" Inherits="Design_Master_EstimateSearch" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/Content/css" />
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/handsontable") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
   
    <link href="../../App_Style/chosen.css" rel="stylesheet" type="text/css" />
     
     <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script> 

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-24">
                    <b>Estimate Report Search</b>
                    <br />
                    <asp:Label ID="lblErr" runat="server" Text="" Style="font-weight: bold; color: red;"></asp:Label>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Estimate Filter</div>
            <div class="row">
                <div class="col-md-2">
                    <label class="pull-left">From Date :</label>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtFromDate" runat="server" Width="110px" />
                    <cc1:CalendarExtender ID="calFromDate" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" runat="server">
                    </cc1:CalendarExtender>
                </div>
                <div class="col-md-2">
                    <label class="pull-left">To Date :</label>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtToDate" runat="server" Width="110px" />
                    <cc1:CalendarExtender ID="calToDate" TargetControlID="txtToDate" Format="dd-MMM-yyyy" runat="server">
                    </cc1:CalendarExtender>
                </div>
                 <div class="col-md-2">
                    <label class="pull-left"> Centre </label>
			  <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <asp:DropDownList ID="ddlCentre" CssClass="ddlCentre chosen-select requiredField"  runat="server"></asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Estimate No. :</label>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtEstimateNo" runat="server" Width="110px" />
                    <cc1:FilteredTextBoxExtender ID="ftbEstimateNo" runat="server" FilterType="Numbers" TargetControlID="txtEstimateNo"></cc1:FilteredTextBoxExtender>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24 " style="text-align: center">
                    <input id="btnSearch" type="button" value="Search" class="searchbutton" onclick="$estimateSearch()" />&nbsp;
                    <input id="btnReport" type="button" value="Detail Report" class="searchbutton" onclick="$estimateReport()" />&nbsp;
                    <input id="Button1" type="button" value="Summary Report" class="searchbutton" onclick="$estimateSummaryReport()" />
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
             <div class="row">
                <div class="col-md-24 " style="text-align: center">
            <div  style="height: 440px;max-height: 440px; min-height: 440px;overflow: hidden;overflow-y: auto;width: 100%;overflow-x:auto ">
                <table style="border-collapse: collapse; width: 100%" id="tblEstimate">
                    <thead>
                        <tr id="DefaultHead">
                            <th class="GridViewHeaderStyle" style="width: 30px;">S.No.</th>
                            <th class="GridViewHeaderStyle" style="width: 50px;">Estimate&nbsp;No.</th>
                            <th class="GridViewHeaderStyle" style="width: 170px;">Name</th>
                            <th class="GridViewHeaderStyle" style="width: 70px;">Age</th>
                            <th class="GridViewHeaderStyle" style="width: 30px;">Sex</th>
                            <th class="GridViewHeaderStyle" style="width: 80px;">Mobile No.</th>
                            <th class="GridViewHeaderStyle" style="width: 170px;">Client Name</th>
                            <th class="GridViewHeaderStyle" style="width: 68px;">Gross Amt.</th>
                            <th class="GridViewHeaderStyle" style="width: 64px;">Disc Amt.</th>
                            <th class="GridViewHeaderStyle" style="width: 64px;">Net Amt.</th>
                            <th class="GridViewHeaderStyle" style="width: 116px;">Reg. Date</th>
                            <th class="GridViewHeaderStyle" style="width: 120px;">Created By</th>
                            <th class="GridViewHeaderStyle" style="width: 30px;">ItemDetail</th>
                            <th class="GridViewHeaderStyle" style="width: 30px;">Reprint</th>
                        </tr>
                    </thead>
                    <tbody >
                    </tbody>
                </table>
            </div>
        </div>
                  </div>
        </div>
    </div>
     <div id="divEstimateItemDetail" tabindex="-1" role="dialog"  class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width:60%">
				<div class="modal-header">
                    <div class="row">
                          <div class="col-md-12" style="text-align:left">
                              <h4 class="modal-title">Estimate Item Detail </h4>
                              </div>
                         <div class="col-md-12" style="text-align:right">
                    <em><span style="font-size: 7.5pt">
					Press esc or click<button type="button" class="closeModel" data-dismiss="divEstimateItemDetail" aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div>
				</div>
				<div class="modal-body">
                    <div class="row">
						 <div class="col-md-4">
							   <label class="pull-left">Estimate ID</label>
							   <b class="pull-right">:</b>
						  </div>
						   <div  class="col-md-2" >
							 <span id="spnEstimateID"></span>    
						  </div>
                         <div class="col-md-2">
							   <label class="pull-left">Name</label>
							   <b class="pull-right">:</b>
						  </div>
						   <div  class="col-md-16" style="text-align:left" >
							 <span id="spnName"></span>    
						  </div>
					</div>	
					<div class="row">

						 <div class="col-md-24">
                               <table style="border-collapse: collapse; width: 100%" id="tblItemDetail">
                    <thead>
                        <tr id="trItemDetail">
                            <th class="GridViewHeaderStyle" style="width: 30px;">S.No.</th>
                            <th class="GridViewHeaderStyle" style="width: 50px;">Test Code</th>
                            <th class="GridViewHeaderStyle" style="width: 240px;">Test Name</th>
                            <th class="GridViewHeaderStyle" style="width: 40px;">Rate</th>
                            <th class="GridViewHeaderStyle" style="width: 46px;">Disc Amt.</th>
                            <th class="GridViewHeaderStyle" style="width: 40px;">Amount</th>
                            
                        </tr>
                    </thead>
                    <tbody >
                    </tbody>
                                   </table>
						</div>	  
					</div>
				</div>
				  
			</div>
		</div>
	</div>
    <script type="text/javascript">
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if (jQuery('#divEstimateItemDetail').is(':visible')) {
                    jQuery('#divEstimateItemDetail').hideModel();
                }

            }

        }
        pageLoad = function (sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        $itemDetail = function (rowID) {
            var EstimateID = $(rowID).closest('tr').find("#tdEstimateID").text();
            jQuery("#tblItemDetail tr:not(#trItemDetail)").remove();
            serverCall('EstimateSearch.aspx/GetEstimateItemData', { EstimateID: EstimateID }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    estimateItemDetail = jQuery.parseJSON($responseData.response);

                    if (estimateItemDetail != null) {
                        jQuery("#spnEstimateID").text(estimateItemDetail[0].EstimateID);
                        jQuery("#spnName").text(estimateItemDetail[0].PName);
                        for (var i = 0; i < estimateItemDetail.length; i++) {

                            var $Tr = [];
                            $Tr.push("<tr>");
                            $Tr.push("<td style='text-align:left' class='GridViewLabItemStyle'>"); $Tr.push(i + 1); $Tr.push("</td>");
                            $Tr.push("<td style='text-align:center' id='tdEstimateID' class='GridViewLabItemStyle'>"); $Tr.push(estimateItemDetail[i].TestCode); $Tr.push("</td>");
                            $Tr.push("<td style='text-align:left' class='GridViewLabItemStyle'>"); $Tr.push(estimateItemDetail[i].ItemName); $Tr.push("</td>");
                            $Tr.push("<td style='text-align:right' class='GridViewLabItemStyle'>"); $Tr.push(estimateItemDetail[i].Rate); $Tr.push("</td>");
                            $Tr.push("<td style='text-align:right' class='GridViewLabItemStyle'>"); $Tr.push(estimateItemDetail[i].DiscAmt); $Tr.push("</td>");
                            $Tr.push("<td style='text-align:right' class='GridViewLabItemStyle'>"); $Tr.push(estimateItemDetail[i].Amount); $Tr.push("</td>");
                            $Tr.push("</tr>");
                            $Tr = $Tr.join("");
                            jQuery("#tblItemDetail tbody").append($Tr);
                        }
                        jQuery('#divEstimateItemDetail').showModel();
                    }
                }

                });
           
           
        }

        $estimateReport = function () {
            serverCall('EstimateSearch.aspx/GetEstimateReport', { fromDate: $("#txtFromDate").val(), toDate: $("#txtToDate").val(), EstimateID: $("#txtEstimateNo").val(), CentreID: $("#<%=ddlCentre.ClientID %>").val(), CentreName: $("#<%=ddlCentre.ClientID %>").find(':selected').text() }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    window.open('../common/ExportToExcel.aspx');
                }
                else {
                    toast("Info", $responseData.response, "");
                }
            });
        }
        $estimateSummaryReport = function () {
            serverCall('EstimateSearch.aspx/GetEstimateReportSummary', { fromDate: $("#txtFromDate").val(), toDate: $("#txtToDate").val(), EstimateID: $("#txtEstimateNo").val(), CentreID: $("#<%=ddlCentre.ClientID %>").val(), CentreName: $("#<%=ddlCentre.ClientID %>").find(':selected').text() }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    window.open('../common/ExportToExcel.aspx');
                }
                else {
                    toast("Info", $responseData.response, "");
                }
            });
        }
        $estimateSearch = function () {
           jQuery("#tblEstimate tr:not(#DefaultHead)").remove();
           serverCall('EstimateSearch.aspx/GetEstimateData', { fromDate: $("#txtFromDate").val(), toDate: $("#txtToDate").val(), EstimateID: $("#txtEstimateNo").val(), CentreID: $("#<%=ddlCentre.ClientID %>").val(), CentreName: $("#<%=ddlCentre.ClientID %>").find(':selected').text() }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                  var  estimateDetail = jQuery.parseJSON($responseData.response);                  
                    if (estimateDetail != null) {
                        for (var i = 0; i < estimateDetail.length; i++) {                          
                            var $Tr = [];
                            $Tr.push("<tr>");
                            $Tr.push("<td style='text-align:left' class='GridViewLabItemStyle'>"); $Tr.push(i + 1); $Tr.push("</td>");
                            $Tr.push("<td style='text-align:center' id='tdEstimateID' class='GridViewLabItemStyle'>"); $Tr.push(estimateDetail[i].EstimateID); $Tr.push("</td>");
                            $Tr.push("<td style='text-align:left' class='GridViewLabItemStyle'>"); $Tr.push(estimateDetail[i].PName); $Tr.push("</td>");
                            $Tr.push("<td style='text-align:left' class='GridViewLabItemStyle'>"); $Tr.push(estimateDetail[i].Age); $Tr.push("</td>");
                            $Tr.push("<td style='text-align:left' class='GridViewLabItemStyle'>"); $Tr.push(estimateDetail[i].Gender); $Tr.push("</td>");
                            $Tr.push("<td style='text-align:left' class='GridViewLabItemStyle'>"); $Tr.push(estimateDetail[i].Mobile); $Tr.push("</td>");
                            $Tr.push("<td style='text-align:left' class='GridViewLabItemStyle'>"); $Tr.push(estimateDetail[i].PanelName); $Tr.push("</td>");
                            $Tr.push("<td style='text-align:right' class='GridViewLabItemStyle'>"); $Tr.push(estimateDetail[i].Rate); $Tr.push("</td>");
                            $Tr.push("<td style='text-align:right' class='GridViewLabItemStyle'>"); $Tr.push(estimateDetail[i].DiscAmt); $Tr.push("</td>");
                            $Tr.push("<td style='text-align:right' class='GridViewLabItemStyle'>"); $Tr.push(estimateDetail[i].Amount); $Tr.push("</td>");
                            $Tr.push("<td style='text-align:left' class='GridViewLabItemStyle'>"); $Tr.push(estimateDetail[i].RegDate); $Tr.push("</td>");

                            $Tr.push("<td style='text-align:left' class='GridViewLabItemStyle'>"); $Tr.push(estimateDetail[i].CreatedBy); $Tr.push("</td>");
                            $Tr.push("<td style='text-align:center' class='GridViewLabItemStyle'>"); $Tr.push("<img onclick='$itemDetail(this)' src='../../App_Images/view.GIF' style='cursor:pointer;'/>"); $Tr.push("</td>");
                            $Tr.push("<td style='text-align:center' class='GridViewLabItemStyle'>"); $Tr.push("<img onclick='$reprint(this)' src='../../App_Images/print.gif' style='cursor:pointer;'/>"); $Tr.push("</td>");

                            $Tr.push("</tr>");
                            $Tr = $Tr.join("");
                            jQuery("#tblEstimate tbody").append($Tr);
                           
                        }
                        $("#tblEstimate").tableHeadFixer({
                        });
                    }
                }
                else {
                    toast("Info", $responseData.response, "");
                }

            });

        }
       
        $reprint = function (rowID) {
            var EstimateID = $(rowID).closest('tr').find("#tdEstimateID").text();
            serverCall('EstimateSearch.aspx/encryptEstimateID', { EstimateID: EstimateID }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    window.open('EstimateReceipt.aspx?ID=' + $responseData.responseDetail + '&IDNew=' + EstimateID + '');
                }
                else {

                }

            });

        }
    </script>
     <script type="text/javascript">
         $(function () {
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
         });
    </script>
</asp:Content>

