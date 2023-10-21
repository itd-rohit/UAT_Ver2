<%@ Page Title="" ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CampReport.aspx.cs" Inherits="Design_Camp_CampReport" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
       <div id="Pbody_box_inventory" >
        <Ajax:ScriptManager ID="sc" runat="server"  EnablePageMethods="true"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Camp Report</b><br />
            <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red" ></asp:Label>
            <asp:Label ID="lblView" runat="server"  style="display:none"></asp:Label>
        </div>
            <div class="POuter_Box_Inventory" > 
            <div class="Purchaseheader">
                Search Criteria
            </div>         
                 <div class="row">
                     <div class="col-md-4">&nbsp;</div>
            <div class="col-md-2">
               <label class="pull-left">From Date   </label>
			   <b class="pull-right">:</b>
                </div>
             <div class="col-md-2">
                  <asp:TextBox ID="txtFromDate" runat="server"  />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                 </div>
                     <div class="col-md-2">&nbsp;</div>
                      <div class="col-md-2">
               <label class="pull-left">To Date   </label>
			   <b class="pull-right">:</b>
                </div>
             <div class="col-md-2">
                 <asp:TextBox ID="txtToDate" runat="server"  />
                        <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                 </div>
             <div class="col-md-2">


                         <input type="button" value="Search" class="searchbutton" onclick="searchCampRequest(0)" id="btnSearch" />
                 </div>

                      <div class="col-md-4">


                         <input type="button" value="Export To Excel" class="searchbutton" onclick="searchCampRequest(1)" id="Button1" />
                 </div>
                     </div>
                                     
                  </div>
    
          <div class="POuter_Box_Inventory">                   
               <div  class="row" id="divCampDetail" style="max-height: 320px; overflow-y: auto; overflow-x: hidden;">                                        
               </div>
              </div>
         </div>
     <div id="divCampTest" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="min-width: 40%; max-width: 42%">
                <div class="modal-header">
                    <div class="row">
                        <div class="col-md-12" style="text-align: left">
                            <h4 class="modal-title">Camp Test Detail</h4>
                        </div>
                        <div class="col-md-12" style="text-align: right">
                            <em><span style="font-size: 7.5pt; color: #0000ff;">Press esc or click
                                <button type="button" class="closeModel" onclick="$closeCampTestModel()" aria-hidden="true">&times;</button>to close</span></em>
                        </div>
                    </div>
                </div>
                <div class="modal-body">
                    <div id="divPopUPCampTest" class="col-md-24">
                        <table id="tblCampTest"  style="width:95%;border-collapse:collapse;margin-left:15px;" class="GridViewStyle">      
                            <thead>
                             <tr>
                                        <td class="GridViewHeaderStyle" style="width:100px" >Code</td>
                                        <td class="GridViewHeaderStyle" style="width:300px">Item</td>
                                        <td class="GridViewHeaderStyle" style="width:110px">Requested Rate</td>                                                                               
                       </tr> 
                                 </thead>
				 <tbody></tbody>    
        </table>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" onclick="$closeCampTestModel()">Close</button>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if (jQuery('#divCampTest').is(':visible')) {
                    jQuery('#divCampTest').hideModel();
                }
            }
        }
        pageLoad = function (sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        $closeCampTestModel = function (callback) {
            jQuery('#divCampTest').hideModel();
        }
        $getCampTestDetail = function (rowID) {
            jQuery('#tblCampTest tr').slice(1).remove();
            serverCall('CampReport.aspx/CampTestDetail', { ID: jQuery(rowID).closest('tr').find("#tdID").text() }, function (response) {
                var $CampData = JSON.parse(response);
                for (var i = 0; i <= $CampData.length - 1; i++) {
                    var $mydata = [];
                    $mydata.push("<tr id='"); $mydata.push($CampData[i].ID); $mydata.push("'>");
                    $mydata.push('<td style="text-align: left"  class="GridViewLabItemStyle">');
                    $mydata.push($CampData[i].testCode);
                    $mydata.push('</td>');
                    $mydata.push('<td style="text-align: left"  class="GridViewLabItemStyle">');
                    $mydata.push($CampData[i].typeName);
                    $mydata.push('</td>');
                    $mydata.push('<td style="text-align: right"  class="GridViewLabItemStyle">');
                    $mydata.push($CampData[i].RequestedRate);
                    $mydata.push('</td>');
                    $mydata.push('</tr>');
                    $mydata = $mydata.join("");
                    jQuery('#tblCampTest tbody').append($mydata);
                }
                jQuery('#divCampTest').showModel();
            })
        }
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
            jQuery('#ddlType,#ddlStatus').trigger('chosen:updated');
            jQuery("#ddlType,#ddlStatus").chosen("destroy").chosen({ width: '100%' });
        });
        function searchCampRequest(searchType) {
            jQuery('#btnSearch').attr('disabled', 'disabled').val('Searching...');
            serverCall('CampReport.aspx/SearchCampRequest', { fromDate: jQuery('#txtFromDate').val(), toDate: jQuery('#txtToDate').val(), searchType: searchType }, function (response) {
                Edata = jQuery.parseJSON(response);
                if (Edata.length == 0) {
                    toast('Info', 'No Camp Request Found');
                    jQuery('#lbltotal').text('0');
                    jQuery('#divCampDetail').hide();
                }
                else if (searchType == "1") {
                    var output = jQuery('#tb_CampDetail').parseTemplate(Edata);
                    jQuery('#divCampDetail').html(output);
                    jQuery('#divCampDetail').show();
                    window.open('../../Design/Common/ExportToExcel.aspx');

                }
                else {
                    var output = jQuery('#tb_CampDetail').parseTemplate(Edata);
                    jQuery('#divCampDetail').html(output);
                    jQuery('#divCampDetail').show();
                }
                jQuery('#btnSearch').removeAttr('disabled').val('Search');
            });
        }
         </script>
    <script id="tb_CampDetail" type="text/html">
    <table  cellspacing="0" rules="all" border="1" id="tb_grdCampDetail"
    style="width:100%;border-collapse:collapse;">
        <thead>
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:30px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:220px;">Camp Centre</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:220px;">Camp Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Camp Type</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Camp Start Date</th>          
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;display:none">Camp End Date</th>          
            <th class="GridViewHeaderStyle" scope="col" style="width:180px;">Created By</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Created Date</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Approved Date</th>                           
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">State</th>   
                        <th class="GridViewHeaderStyle" scope="col" style="width:60px;">City</th>    
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Locality</th>    
 
		</tr>
             </thead>
        <#
        var dataLength=Edata.length;      
        var objRow;           
        for(var j=0;j<dataLength;j++)
        {
        objRow = Edata[j];
        #>
                    <tr id="<#=j+1#>"
                        <#
 if(objRow.IsActive ==0)
                        {#>
                        style="background-color:#FFFFFF"
                        <#}
                       
                        else if(objRow.IsCreated ==0)
                        {#>
                        style="background-color:#B0C4DE"
                        <#}                                            
                         else if(objRow.IsCreated ==1)
                        {#>
                         style="background-color:#FFC0CB"
                        <#}                       
                        #>                       
                         >
                    <td class="GridViewLabItemStyle"><#=j+1#></td>
                    <td class="GridViewLabItemStyle"><#=objRow.Company_Name#></td>
                    <td class="GridViewLabItemStyle" id="tdCampName" ><#=objRow.CampName#></td>
                    <td class="GridViewLabItemStyle" id="tdCampType" ><#=objRow.CampType#></td>
                    <td class="GridViewLabItemStyle" id="tdStartDate" ><#=objRow.StartDate#></td>
                    <td class="GridViewLabItemStyle" style="display:none" ><#=objRow.EndDate#></td>                                         
                    <td class="GridViewLabItemStyle"  ><#=objRow.CreatedBy#></td>
                    <td class="GridViewLabItemStyle" ><#=objRow.CreatedDate#></td> 
                    <td class="GridViewLabItemStyle" ><#=objRow.ApprovedDate#></td>                                                  
                    <td class="GridViewLabItemStyle" id="tdID" style="display:none" ><#=objRow.ID#></td>  
                    <td class="GridViewLabItemStyle" ><#=objRow.State#></td>                                                  
                    <td class="GridViewLabItemStyle" ><#=objRow.City#></td>                                                  
                    <td class="GridViewLabItemStyle" ><#=objRow.Locality#></td>                                                  

                                             
                    </tr>
        <#}
        #>       
     </table>
    </script>
    <script type="text/javascript">
        function $CampCreate(rowid) {
            jQuery(rowid).closest('tr').find("#btnCreate").val('Submitting...').attr('disabled', 'disabled');
            serverCall('CampReport.aspx/CreateCampRequest', { ID: jQuery(rowid).closest('tr').find("#tdID").text() }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.Status) {

                    jQuery(rowid).closest('tr').find("#btnCreate").hide();
                    window.open('../Master/CampMaster.aspx?ID=' + $responseData.response + '');
                }
                else {
                    jQuery(rowid).closest('tr').find("#btnCreate").val('Create').removeAttr('disabled');
                    toast("Error", $responseData.response, "");
                }
            });
        }
        function accessRight() {
            jQuery('#btnSearch').hide();
        }
    </script>
</asp:Content>

