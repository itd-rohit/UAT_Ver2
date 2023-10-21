<%@ Page Language="C#" ClientIDMode="Static" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="MembershipCardSearch.aspx.cs" Inherits="Design_MemberShipCard_MembershipCardSearch"  %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
     <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 
     <%: Scripts.Render("~/bundles/Chosen") %>
     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>

    
    
     <div id="Pbody_box_inventory" >
         <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">    
        </Ajax:ScriptManager>
          <div class="POuter_Box_Inventory" style="text-align:center;">          
                          <b>Membership Card Search</b>                                         
              </div>
               <div class="POuter_Box_Inventory" >
           <div class="row">
               
                <div class="col-md-3 ">
                    <label class="pull-left">Issue Date From   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 ">
                   <asp:TextBox ID="txtFromDate" runat="server" ReadOnly="true" class="setmydate" Width="150px"></asp:TextBox>
                     <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
                <div class="col-md-3 ">
                    <label class="pull-left">Issue Date To   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 ">
                    <asp:TextBox ID="txtToDate" runat="server" ReadOnly="true" class="setmydate" Width="150px"></asp:TextBox>
                     <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                </div>
               <div class="col-md-3 ">
                    <label class="pull-left">Membership Card No.   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 ">
                    <asp:TextBox ID="txtMembershipCardNo" runat="server" Width="150px" />
                    </div>
            </div>
                     <div class="row">
               
                <div class="col-md-3 ">
                    <label class="pull-left">Card Type   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 ">
                    <asp:DropDownList ID="ddlCardType" runat="server" Width="150px" CssClass="ddlCardType chosen-select"/> 
                    </div>
       <div class="col-md-3 ">
                    <label class="pull-left">UHID No.   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 ">
                    <asp:TextBox ID="txtUHIDNo" runat="server" Width="150px"></asp:TextBox>
                    </div>
      <div class="col-md-3 ">
                    <label class="pull-left">Mobile No.   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5 ">
                    <asp:TextBox ID="txtMobileNo" runat="server" Width="150px"></asp:TextBox>
                    <cc1:FilteredTextBoxExtender ID="ftbtxtMobile" runat="server" TargetControlID="txtMobileNo" ValidChars="0123456789"></cc1:FilteredTextBoxExtender>
                    </div>
      </div>
                      </div>
                   <div class="POuter_Box_Inventory" style="text-align: center">
                        <input type="button" value="Search" onclick="$searchMembershipCard()" />
                        </div>
          
                 
              <div class="POuter_Box_Inventory" >   
                  <div id="divMemberShip" style="max-height:350px; overflow:auto; ">            
            </div>                                                             
         </div>   </div>
    

         <div id="divCardDetail" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="min-width: 66%;max-width:50%">
			<div class="modal-header">
                 <div class="row">
                          <div class="col-md-8" style="text-align:left">
                              <h4 class="modal-title">Test Detail&nbsp&nbsp&nbsp<b>Card No. :<span id="spnPopupCard"></span> </b></h4>
                              </div>
                      <div class="col-md-8" style="text-align:left">
                          <span id="spnShowUHID"> UHID No. :&nbsp; <span id="spnUHIDNo"></span></span>
                          </div>
                         <div class="col-md-8" style="text-align:right">
                    <em><span style="font-size: 7.5pt;color: #0000ff;">
					Press esc or click<button type="button" class="closeModel"  onclick="$closeCardDetailModel()" aria-hidden="true">&times;</button>to close</span></em></div>					
                         </div>				
				<h4 class="modal-title"></h4>
			</div>
			<div class="modal-body" >
                <div style="height:200px"  class="row">
					<div id="divCardDetailData" class="col-md-24" style="max-height: 440px; overflow: auto; width: 860px;display:none">
                       <table id="tblCardDetail" style="width:99%;border-collapse:collapse;text-align:left;">    
                            <thead>
                            <tr id="trItemDetail">
                             <td class="GridViewHeaderStyle" style="width:50px;">S.No.</td>                        
                             <td class="GridViewHeaderStyle" style="width:150px;">Department</td>
                             <td class="GridViewHeaderStyle" style="width: 80px;">Test Code</td>
                             <td class="GridViewHeaderStyle" style="width:480px;">TestName</td>
                             <td class="GridViewHeaderStyle" style="width:80px;">SelfDisc</td>
                             <td class="GridViewHeaderStyle" style="width:80px;">DeptDisc</td>
                             <td class="GridViewHeaderStyle" style="width:80px;">SelfFreeTestCount</td>
                             <td class="GridViewHeaderStyle" style="width:80px;">DeptFreeTestCount</td>
                            </tr>
                                </thead>
							<tbody></tbody>
                        </table>
					</div>


                      
           
            
               <div id="divTestDetails" class="col-md-24" style="max-height: 440px; overflow: auto; width: 860px;display:none">  
                   
            </div>
				 </div>
                </div>
            <div class="modal-footer">				
				<button type="button"  onclick="$closeCardDetailModel()">Close</button>
			</div>
            </div>
        </div>
         </div>
        <script id="sc_Membership" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1"   id="tblMembership"
    style="width:100%;border-collapse:collapse;">
            <thead>
		<tr>
			 <td class="GridViewHeaderStyle" style="width:50px;">S.No.</td>                        
                         <td class="GridViewHeaderStyle" style="width:140px;">Card Name</td>
                         <td class="GridViewHeaderStyle" style="width:100px;">Card No.</td>
                         <td class="GridViewHeaderStyle" style="width:140px;">Issue Date Time</td>
                         <td class="GridViewHeaderStyle" style="width:90px;">Mobile No.</td>
                         <td class="GridViewHeaderStyle" style="width:220px;">Member Name</td>
                         <td class="GridViewHeaderStyle" style="width:100px;">Age</td>
                         <td class="GridViewHeaderStyle" style="width:50px;">Gender</td>
                         <td class="GridViewHeaderStyle" style="width:80px;">Expiry Date</td>
                         <td class="GridViewHeaderStyle" style="width:80px;">Card Price</td>                                  
                         <td class="GridViewHeaderStyle" style="width:180px;">Issue By</td>
                         <td class="GridViewHeaderStyle" style="width:40px;">View</td>  
                         <td class="GridViewHeaderStyle" style="width:40px;">Edit</td>  
                         <td class="GridViewHeaderStyle" style="width:60px;">Receipt</td> 
                                           
		</tr>
                </thead>
  <#  
              var dataLength=MembershipData.length;
              var objRow;   
              var status;
        for(var j=0;j<dataLength;j++)
        {
        objRow = MembershipData[j];      
           #>          
                    <tr  >
<td class="GridViewLabItemStyle"><#=j+1#>   
    <img src="../../App_Images/details_open.png"  style="cursor:pointer" onclick="showMembershipDetail(this)" id="imgPlus" />
    <img src="../../App_Images/details_close.png"  style="cursor:pointer; display:none" onclick="hideMembershipDetail(this)" id="imgMinus" />    
</td>
<td class="GridViewLabItemStyle"><#=objRow.cardName#></td>
<td class="GridViewLabItemStyle" id="tdCardNo"><#=objRow.cardno#></td>
<td class="GridViewLabItemStyle"><#=objRow.entrydate#></td>
<td class="GridViewLabItemStyle"><#=objRow.mobile#></td>
<td class="GridViewLabItemStyle"><#=objRow.name#></td>
<td class="GridViewLabItemStyle"><#=objRow.age#></td>
<td class="GridViewLabItemStyle"><#=objRow.gender#></td>
<td class="GridViewLabItemStyle"><#=objRow.ValidTo#></td>
<td class="GridViewLabItemStyle" style="text-align:right"><#=objRow.amount#></td>

<td class="GridViewLabItemStyle"><#=objRow.issueby#></td>
 <td class="GridViewLabItemStyle" style="text-align: center"><img src="../../App_Images/View.gif" onclick="viewdetail(this)" style="cursor:pointer;" /></td>
<td class="GridViewLabItemStyle" style="display:none" id="tdID"><#=objRow.ID#></td>
<td class="GridViewLabItemStyle" style="display:none" id="tdFamilyMemberGroupID"><#=objRow.FamilyMemberGroupID#></td>
<td class="GridViewLabItemStyle" style="text-align: center" id="td2"><img src="../../App_Images/edit.png" onclick="openpopup1('<#=objRow.cardno#>')" style="cursor:pointer;" /></td>
<td class="GridViewLabItemStyle" style="text-align: center" id="td1"><img src="../../App_Images/folder.gif" onclick="openpopup4('<#=objRow.LedgerTransactionID#>')" style="cursor:pointer;" /></td>
                       
</tr>
            <tr id="tr_Detail_<#=objRow.ID#>" style="background-color:#FFFFFF;display:none" >
            <td colspan="9" id="td_Detail_<#=objRow.ID#>">               
            </td></tr>
            <#}#>
     </table>  
         
    </script>
        <script id="tb_MembershipDetail" type="text/html">   
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1"   id="tblMembershipDetail"
    style="width:840px;border-collapse:collapse;">                                  
		<tr id="trMembershipDetail">
            <th style="width:6%;"></th>		
            <th class="GridViewHeaderStyle" scope="col" style="width:30px">S.&nbsp;No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:240px">Member Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px">UHID No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px">Mobile No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px">Age</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px">Gender</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px">Relation</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:30px">View</th>
            <th  style="width:30px;"></th>
</tr>
       <#       
              var dataLength=MembershipDetail.length;
              var objRow;   
        for(var k=0;k<dataLength;k++)
        {
        objRow = MembershipDetail[k];      
            #>        
                  <tr >
                      <td style="width:6%;">                   
                      </td>
                    <td class="GridViewLabItemStyle"><#=k+1#>  </td>
                    <td class="GridViewLabItemStyle" ><#=objRow.pname#></td>
                    <td class="GridViewLabItemStyle" id="tdPatient_ID" ><#=objRow.patient_id#></td>
                    <td class="GridViewLabItemStyle" ><#=objRow.Mobile#></td>      
                    <td class="GridViewLabItemStyle" ><#=objRow.age#></td>                 
                    <td class="GridViewLabItemStyle" ><#=objRow.gender#></td>
                    <td class="GridViewLabItemStyle" ><#=objRow.relation#></td>
                    <td class="GridViewLabItemStyle" id="tdFamilyMemberIsPrimary" style="display:none" ><#=objRow.IsPrimary#></td>  
                    <td class="GridViewLabItemStyle" style="text-align:center" > <img src="../../App_Images/view.gif" onclick="viewAllDetail(this)" style="cursor:pointer;" /></td>
                    <td style="width:30px;" >                
                      </td>                                                                
                 </tr>
            <#}#>                      
     </table>     
    </script>
        <script id="sc_TestDetail" type="text/html">   
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1"   id="tblTestDetail"
    style="width:840px;border-collapse:collapse;"> 
            <thead>
            <#       
              var dataLength=MembershipAllDetail.length;
              var objRow;   
        for(var k=0;k<dataLength;k++)
        {
        objRow = MembershipAllDetail[k];      
            #>        
            <#if(k==0)
            {#>                                  
		<tr id="trTestDetail">
             <th class="GridViewHeaderStyle" style="width:60px;">S.No.</th>
             <th class="GridViewHeaderStyle" style="width:150px;">Department</th>
             <th class="GridViewHeaderStyle" style="width:80px;">TestCode</th>
             <th class="GridViewHeaderStyle" style="width:480px;">TestName</th>
            <# if(objRow.FamilyMemberIsPrimary==1 ){#>
                   <th class="GridViewHeaderStyle" style="width:80px;">SelfDisc</th>
                   <th class="GridViewHeaderStyle" style="width:80px;">SelfFreeTestCount</th>
                   <th class="GridViewHeaderStyle" style="width:80px;">SelfFreeTestConsume</th>
             <#}
              else {#> 
             <th class="GridViewHeaderStyle" style="width:80px;">DeptDisc</th>           
             <th class="GridViewHeaderStyle" style="width:80px;">DeptFreeTestCount</th>
             <th class="GridViewHeaderStyle" style="width:80px;">DeptFreeTestConsume</th>
           
            <#}#>
</tr> </thead> <tbody>
            <#} #> 
               
                  <tr >
                    <td class="GridViewLabItemStyle"><#=k+1#>  </td>
                    <td class="GridViewLabItemStyle"><#=objRow.deptname#></td>
                      <td class="GridViewLabItemStyle"><#=objRow.TestCode#></td>
                    <td class="GridViewLabItemStyle"><#=objRow.ItemName#></td>
                      <# if(objRow.FamilyMemberIsPrimary==1 ){#>
                    <td class="GridViewLabItemStyle" style="text-align:right"><#=objRow.SelfDisc#></td>                                   
                    <td class="GridViewLabItemStyle" style="text-align:right"><#=objRow.SelfFreeTestCount#></td>
                    <td class="GridViewLabItemStyle" style="text-align:right"><#=objRow.SelfFreeTestConsume#></td> 
                      <#}
                   else {#> 
                      <td class="GridViewLabItemStyle" style="text-align:right"><#=objRow.DependentDisc#></td>  
                      <td class="GridViewLabItemStyle" style="text-align:right"><#=objRow.DependentFreeTestCount#></td>
                      <td class="GridViewLabItemStyle" style="text-align:right"><#=objRow.DependentFreeTestConsume#></td>
                      <#}#>                                                                                                                          
                 </tr>
            <#}#>                      
    </tbody> </table>     
    </script>
    <script type="text/javascript">
        $closeCardDetailModel = function () {
            jQuery('#divCardDetail').hideModel();
        }
        function hideMembershipDetail(rowID) {
            $(rowID).closest('tr').find('#imgMinus').hide();
            $(rowID).closest('tr').find('#imgPlus').show();
            var ID = $(rowID).closest('tr').find('#tdID').text();
            $('#tr_Detail_' + ID).hide();
        }
        function showMembershipDetail(rowID) {
            var ID = $(rowID).closest('tr').find('#tdID').text();
            var FamilyMemberGroupID = $(rowID).closest('tr').find('#tdFamilyMemberGroupID').text();
            serverCall('MembershipCardSearch.aspx/bindMembershipMember', { FamilyMemberGroupID: FamilyMemberGroupID }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    var ID = $(rowID).closest('tr').find('#tdID').text();
                    MembershipDetail = jQuery.parseJSON($responseData.response);                   
                    if (MembershipDetail != null) {
                        var output = $('#tb_MembershipDetail').parseTemplate(MembershipDetail);
                        $('#td_Detail_' + ID).html(output);
                        $('#td_Detail_' + ID).show();
                        $('#tr_Detail_' + ID).show();
                        $(rowID).closest('tr').find('#imgMinus').show();
                        $(rowID).closest('tr').find('#imgPlus').hide();
                    }
                    else {

                    }
                }

            });           
        }              
        function openpopup1(CardNo) {
            serverCall('MembershipCardSearch.aspx/encryptCardNo', { CardNo: CardNo }, function (response) {               
                window.open("MemberShipCardIssueEdit.aspx?CardNo=" + response);
            });          
        }
        function openpopup4(labno) {
            serverCall('MembershipCardSearch.aspx/EncryptData', { data: labno }, function (response) {
                window.open("../Lab/PatientReceiptNew1.aspx?LabID=" + response);
            });           
        }              
        function viewAllDetail(rowID) {
            $modelBlockUI();
            $('#divMasterTestDetail').hide();
            $('#tblCardDetail tr').slice(1).remove();
            var Patient_ID = $(rowID).closest('tr').find('#tdPatient_ID').text();
            $('#spnUHIDNo').text(Patient_ID);
            $('#spnShowUHID').show();
            var FamilyMemberIsPrimary = $(rowID).closest('tr').find('#tdFamilyMemberIsPrimary').text();
            serverCall('MembershipCardSearch.aspx/getAllCardDetail', { Patient_ID: Patient_ID, FamilyMemberIsPrimary: FamilyMemberIsPrimary }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    MembershipAllDetail = jQuery.parseJSON($responseData.response);
                    var output = $('#sc_TestDetail').parseTemplate(MembershipAllDetail);
                    $('#divTestDetails').html(output);
                    jQuery('#divCardDetailData').hide();
                    jQuery('#divTestDetails').show();
                    jQuery('#divCardDetail').showModel();
                    
                    jQuery("#tblTestDetail").tableHeadFixer({
                    });
                }
                else {
                    jQuery('#divCardDetail').hideModel();
                }
            });          
        }       
    </script>
    <script type="text/javascript">
        function $searchMembershipCard() {
            jQuery('#tblMembership tr').empty();
            serverCall('MembershipCardSearch.aspx/searchcard', { fromdate: $('#txtFromDate').val(), todate: $('#txtToDate').val(), cardtype: $('#ddlCardType').val(), cardno: $('#txtMembershipCardNo').val(), UHIDNo: $('#txtUHIDNo').val(), mobileno: $('#txtMobileNo').val() }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    MembershipData = jQuery.parseJSON($responseData.response);
                    if (MembershipData != null) {
                        var output = jQuery('#sc_Membership').parseTemplate(MembershipData);
                        jQuery('#divMemberShip').html(output);
                        jQuery('#divMemberShip').show();
                        jQuery("#tblCardDetail").tableHeadFixer({
                        });
                    }
                }
	       else
		{
                 toast("Info",$responseData.response,"")
		}
            });            
        }
        function viewdetail(ctrl) {          
            $('#divTestDetails,#spnShowUHID').hide();
            $('#tblCardDetail tr').slice(1).remove();
            $('#spnPopupCard').html($(ctrl).closest('tr').find('#tdCardNo').text());
            serverCall('MembershipCardSearch.aspx/getcarddetail', { FamilyMemberGroupID:$(ctrl).closest('tr').find('#tdFamilyMemberGroupID').text() }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    var MembershipCardDetail = jQuery.parseJSON($responseData.response);
                    if (MembershipCardDetail != null) {
                        for (var i = 0; i <= MembershipCardDetail.length - 1; i++) {
                            var $mydata = [];
                            $mydata.push('<tr  class="GridViewItemStyle">');
                            $mydata.push('<td  class="GridViewItemStyle" align="left" >'); $mydata.push(parseFloat(i + 1)); $mydata.push('</td>');
                            $mydata.push('<td  class="GridViewItemStyle" align="left" >'); $mydata.push(MembershipCardDetail[i].deptname); $mydata.push('</td>');
                            $mydata.push('<td  class="GridViewItemStyle" align="left" >'); $mydata.push(MembershipCardDetail[i].TestCode); $mydata.push('</td>');
                            $mydata.push('<td  class="GridViewItemStyle" align="left" >'); $mydata.push(MembershipCardDetail[i].ItemName); $mydata.push('</td>');
                            $mydata.push('<td  class="GridViewItemStyle" align="right" >'); $mydata.push(MembershipCardDetail[i].SelfDisc); $mydata.push('</td>');
                            $mydata.push('<td  class="GridViewItemStyle" align="right" >'); $mydata.push(MembershipCardDetail[i].DependentDisc); $mydata.push('</td>');
                            $mydata.push('<td  class="GridViewItemStyle" align="right" >'); $mydata.push(MembershipCardDetail[i].SelfFreeTestCount); $mydata.push('</td>');
                            $mydata.push('<td  class="GridViewItemStyle" align="right" >'); $mydata.push(MembershipCardDetail[i].DependentFreeTestCount); $mydata.push('</td>');
                            $mydata.push('</tr>');
                            $mydata = $mydata.join("");
                            $('#tblCardDetail').append($mydata);
                        }
                        jQuery('#divCardDetailData').show();
                        jQuery('#divTestDetails').hide();
                        jQuery('#divTestDetails').html('');
                        jQuery('#divCardDetail').showModel();
                        jQuery("#tblCardDetail").tableHeadFixer({
                        });
                    }                  
                }
            });                       
        }       
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

