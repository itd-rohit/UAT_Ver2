<%@ Page Language="C#" AutoEventWireup="true" CodeFile="InvoiceReprint.aspx.cs" ClientIDMode="Static" Inherits="Design_Invoicing_InvoiceReprint"  MasterPageFile="~/Design/DefaultHome.master"%>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/UserControl/PanelGroup.ascx" TagPrefix="uc1" TagName="PanelGroup" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
       <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
       <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
      <script type="text/javascript" src="../../Scripts/jquery.blockUI.js"></script>
       <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
       <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
     <link href="../../App_Style/multiple-select.css" rel="stylesheet"/>
    <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
    <script src="../../Scripts/jquery-confirm.min.js" type="text/javascript"></script>
<style type="text/css">
    .multiselect {
        width: 100%;
    }
</style>
    <script type="text/javascript">

        jQuery(function () {
            jQuery('[id*=lstPanel],[id*=lstcentre]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
        });


         </script> 

   
  
  <div id="Pbody_box_inventory">
       <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true">
           <Services>
               <Ajax:ServiceReference Path="../Common/Services/CommonServices.asmx" />
               <Ajax:ServiceReference Path="Services/Panel_Invoice.asmx" />

           </Services>
        </Ajax:ScriptManager>
       <asp:TextBox ID="txtInvoiceNo" runat="server" style="display:none" />
     
        <div  class="POuter_Box_Inventory"  style="text-align: center;" >                        
            <asp:Label ID="lblSearchType" runat="server" Style="display: none" ClientIDMode="Static" />
       <div class="row">
                <div class="col-md-24" style="text-align:center">
                 <b>Invoice Reprint</b>
                    </div>
                     </div>
              <div class="row" id="tblType">
                  <div class="col-md-10"></div>
                <div class="col-md-14" style="text-align:center;display:none;">
                    <uc1:PanelGroup runat="server" ID="rblSearchType" ClientIDMode="Static" /> 
                    </div>
                  </div>       
            </div>
        <div  id="SearchDiv" class="POuter_Box_Inventory" >
           
              <div class="row">
               <div class="col-md-3">
                   </div>
                <div class="col-md-3">
                    <label class="pull-left">From Date</label>
                    <b class="pull-right">:</b>
                    </div>
                 <div class="col-md-2">
                      <asp:TextBox ID="dtFrom" runat="server" ></asp:TextBox>
<cc1:CalendarExtender runat="server" ID="calFromDate"
    TargetControlID="dtFrom"
    Format="dd-MMM-yyyy"
     />
           </div>
                  <div class="col-md-5">
                   </div>
                   <div class="col-md-3">
                    <label class="pull-left">To Date</label>
                    <b class="pull-right">:</b>
                    </div>
                 <div class="col-md-2">
                      <asp:TextBox ID="dtTo" runat="server"  ></asp:TextBox>
<cc1:CalendarExtender runat="server" ID="calToDate" TargetControlID="dtTo" Format="dd-MMM-yyyy"/>

                     </div>

                  </div>
            <div class="row trType">
               <div class="col-md-3">
                   </div>
                <div class="col-md-3">
                    <label class="pull-left">Invoice No.</label>
                    <b class="pull-right">:</b>
                    </div>
                 <div class="col-md-5">
                      <asp:TextBox ID="txtInvoice" runat="server" ></asp:TextBox>
                     </div>
                 <div class="col-md-2">
                   </div>
                 <div class="col-md-3">
                    <label class="pull-left">Date Type</label>
                    <b class="pull-right">:</b>
                    </div>
                 <div class="col-md-5">
                     <asp:DropDownList ID="ddlDateType"  runat="server">
                            <asp:ListItem Value="im.EntryDate">Entry Date</asp:ListItem>
                             <asp:ListItem Value="im.InvoiceDate" Selected="True">Invoice Date</asp:ListItem>
                        </asp:DropDownList>
                     </div>
                </div>

                <div class="row trType">
               <div class="col-md-3">
                   </div>
                <div class="col-md-3">
                    <label class="pull-left">Business Zone</label>
                    <b class="pull-right">:</b>
                    </div>
                 <div class="col-md-5">
                      <asp:DropDownList ID="ddlBusinessZone" runat="server" onchange="bindState()" class="ddlBusinessZone chosen-select">
                              </asp:DropDownList>
                     </div>
                    <div class="col-md-2">
                   </div>
                     <div class="col-md-3">
                    <label class="pull-left">State</label>
                    <b class="pull-right">:</b>
                    </div>
                 <div class="col-md-5">
                     <asp:DropDownList ID="ddlState" runat="server" onchange="bindPanel()"  class="ddlState chosen-select">
                        </asp:DropDownList>
                    </div>
 </div>
              <div class="row">
               <div class="col-md-3">
                   </div>
                   <div class="col-md-3">
                    <label class="pull-left">Business Unit</label>
                    <b class="pull-right">:</b>
                    </div>
                 <div class="col-md-5">
                  <asp:ListBox ID="lstcentre" runat="server" CssClass="multiselect" onchange="bindPanel()" SelectionMode="Multiple"></asp:ListBox>
                    </div><div class="col-md-2">
                   </div>
                <div class="col-md-3">
                    <label class="pull-left">Client Name</label>
                    <b class="pull-right">:</b>
                    </div>
                 <div class="col-md-5">
                     <asp:ListBox ID="lstPanel" runat="server" CssClass="multiselect" SelectionMode="Multiple"></asp:ListBox> 
                     </div>
                  </div>

             <div class="row trType">
               <div class="col-md-3">
                   </div>
                <div class="col-md-3">
                    <label class="pull-left">Client Name</label>
                    <b class="pull-right">:</b>
                    </div>
                 <div class="col-md-5">
                     <asp:TextBox ID="txtPanelName" runat="server" ClientIDMode="Static"></asp:TextBox>
                     <input id="hdPanelID" type="hidden" />
                     </div>
                 </div>
            </div>

            <div class="POuter_Box_Inventory" style="text-align: center;"> 
                 <div class="row">
               <div class="col-md-8">
                   </div>
                     <div class="col-md-8">
                       <input id="btnSearch" type="button" value="Search"  class="searchbutton"  onclick="$searchInvoice()" />
                       <input id="btnReport" type="button" value="Report"  class="searchbutton" style="display:none " />
                       <input id="btnCancel" type="button" value="Cancel"  class="searchbutton"  onclick="clearControl()" />
                         <input id="Button2" type="button" value="Cancel Report"  class="searchbutton"  onclick="cancelinvoice()" />
						 <input id="btnsummary" type="button" value="Summary Report"  class="searchbutton"  onclick="searchInvoiceSummary()" />  
                </div>
                     <div class="col-md-8">
                   </div>
 </div> 
                <div class="row">
                    <div class="col-md-10">
                   </div>
                    <div class="col-md-2" style="background-color:#3399FF;border:1px solid black;cursor:pointer;">
                        <b>Dispatch</b>
                   </div><div class="col-md-1"> </div>
                    <div class="col-md-2" style="background-color:#90EE90;border:1px solid black;cursor:pointer;" >
                        <b>NotDispatch</b>
                    </div>
                    </div>

            </div>
                    
              <div class="POuter_Box_Inventory" >
                  
            <div class="Purchaseheader">
                Search Result
            </div>
                   
           <div id="div_Data" style="max-height:350px; overflow:auto;">
              </div>  
              </div> 
         
            
      
            </div>

          <asp:Panel ID="pnlEmail" runat="server" CssClass="pnlItemsFilter" Style="display: none" 
                    Width="600px" >
                 <div  class="Purchaseheader"  runat="server">  
                        Email Invoice

                    </div>
                    <table style="width:100%;border-collapse:collapse">
                        <tr>
                            <td style="text-align:right">Email To Address :&nbsp;
                            </td>
                            <td>
                               <asp:TextBox ID="txtEmailID" runat="server" Width="400px" TextMode="MultiLine" Height="60px"></asp:TextBox>

                                <asp:Label ID="lbInvoiceNo" runat="server" style="display:none;"></asp:Label>
                                <asp:Label ID="lblPanelID" runat="server" style="display:none;"></asp:Label>
                                <asp:Label ID="lblInvoiceType" runat="server" style="display:none;"></asp:Label>

                            </td>
                        </tr>
<tr>
<td>&nbsp;</td>
                            <td >
                                <em ><span style="color: #0000ff; font-size: 7.5pt">
                       (use commas as separating multiple email recipients)</span></em>
                            </td>
                        </tr>
                       <tr>
                            <td style="text-align:right">Email CC Address :&nbsp;
                            </td>
                            <td>
                               <asp:TextBox ID="txtEmailCcAddress" runat="server" Width="400px" TextMode="MultiLine" Height="60px"></asp:TextBox>

                                

                            </td>
                        </tr>
<tr>
<td>&nbsp;</td>
                            <td >
                                <em ><span style="color: #0000ff; font-size: 7.5pt">
                       (use commas as separating multiple emailCC recipients)</span></em>
                            </td>
                        </tr>
                        <tr>
                            
                            <td colspan="2" style="text-align:center">

                                <input type="button" id="btnSendMail" value="Send Mail" onclick="sendMail()" class="ItDoseButton"/>
                             
                              
                                &nbsp;
                                    <asp:Button ID="btnEmailCancel" runat="server" CssClass="ItDoseButton" Text="Cancel"
                                        ToolTip="Click To Cancel" />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
                <asp:Button ID="Button4" runat="server" style="display:none;" />
             <cc1:ModalPopupExtender ID="mpEmail" runat="server" BackgroundCssClass="filterPupupBackground"
                    CancelControlID="btnEmailCancel" DropShadow="true" PopupControlID="pnlEmail"  
                    TargetControlID="btnHide" BehaviorID="mpEmail">
                </cc1:ModalPopupExtender>  




             <asp:Panel ID="pnlReport" runat="server" CssClass="pnlItemsFilter" Style="display: none" 
                    Width="500px" >
                 <div id="Div2" class="Purchaseheader"  runat="server">  
                        Report

                    </div>
                    <table style="width:100%">
                        <tr>
                            <td style="text-align:right">Report Type :
                            </td>
                            <td>
                                <asp:RadioButtonList ID="rdoReport" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Value="1" Selected="True">Summary</asp:ListItem>
                                <asp:ListItem Value ="2" >Invoice Item Wise</asp:ListItem>
                                <asp:ListItem Value="3">Detail (Patient Wise)</asp:ListItem>
                                <asp:ListItem Value="5">Invoice Receipt</asp:ListItem>
                                </asp:RadioButtonList>

                            </td>
                        </tr>
                        <tr>
                            
                            <td colspan="2" style="text-align:center">
                                <input type="button" onclick="ReportOpen();" value="Report" class="ItDoseButton" id="Button1" title="Click To Save" />
                                &nbsp;
                                    <asp:Button ID="btnRCancel" runat="server" CssClass="ItDoseButton" Text="Cancel"
                                        ToolTip="Click To Cancel" />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
                <asp:Button ID="btnHide" runat="server" style="display:none;" />
             <cc1:ModalPopupExtender ID="mpreport" runat="server" BackgroundCssClass="filterPupupBackground"
                    CancelControlID="btnRCancel" DropShadow="true" PopupControlID="pnlReport"  
                    TargetControlID="btnHide" BehaviorID="mpreport">
                </cc1:ModalPopupExtender>  
             
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
                  jQuery(selector).chosen(config[selector]);
              }
              jQuery('#ddlBusinessZone').trigger('chosen:updated');
			  bindState();
          });
   </script>
 <script id="tb_InvestigationItems" type="text/html">

   <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch" 
    style="border-collapse:collapse;width:100%">
        <thead>
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:120px;">Invoice No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:40px;">Client Code</th>
			            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Business Unit</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:360px;">Client Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">Invoice Date</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:210px;">Created By</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Share Amt.</th> 
          
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">View Invoice</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width:50px;">View Report</th>
                        <th class="GridViewHeaderStyle" scope="col" style="width:10px;display:none">Download</th> 
<# if(<%=UserInfo.RoleID %>==1 && <%=UserInfo.RoleID %>==177 && <%=UserInfo.RoleID %>==6) {#> 
                        <th class="GridViewHeaderStyle" scope="col" style="width:10px;">Email</th>  <#}#>  
            <th class="GridViewHeaderStyle" scope="col" style="width:10px;display:none;">Ledger</th> 
</tr>
             </thead>
       <#
              var dataLength=InvoiceData.length;
              var objRow; 
              for(var j=0;j<dataLength;j++)
               {                 
                  objRow = InvoiceData[j];   
        #>
                    <tr id="<#=objRow.InvoiceNo#>"
<#if(objRow.IsDispatch =="1")
                        {#>
                        style="background-color:#3399FF"
                        <#}                                             
                        else if(objRow.IsDispatch =="0")
                        {#>
                        style="background-color:#90EE90"
                        <#}
                        #>>
<td class="GridViewLabItemStyle"><#=j+1#></td>

<td id="tdInvoiceNo"  class="GridViewLabItemStyle"><#=objRow.InvoiceNo#></td>
<td id="PanelName"  class="GridViewLabItemStyle" ><#=objRow.Panel_Code#></td>
<td id="td1"  class="GridViewLabItemStyle"><#=objRow.Centre#></td>
<td id="PanelName"  class="GridViewLabItemStyle" ><#=objRow.PanelName#></td>
<td   class="GridViewLabItemStyle" style="text-align:center"><#=objRow.DATE#></td>
<td id="InvName"  class="GridViewLabItemStyle" ><#=objRow.InvoiceCreatedBy#></td>
<td id="ShareAmt"  class="GridViewLabItemStyle" style="text-align:right"><#=objRow.ShareAmt#></td>  
<td id="tdPanelInvoiceEmailID"  class="GridViewLabItemStyle" style=" display:none"><#=objRow.PanelInvoiceEmailID#></td>
                     <td id="tdInvoiceType"  class="GridViewLabItemStyle" style=" display:none"><#=objRow.InvoiceType#></td>
<td class="GridViewLabItemStyle" style="text-align:center;">
    <img id="view" src="../../App_Images/Post.gif" style="cursor:pointer;" onclick="ReportPopUp(this);" title="Click to View Invoice"/>
 <%--<a target="_blank"  href='InvoiceReceipt.aspx?InvoiceNo=<#=objRow.InvoiceNo#>&Type=<#=objRow.InvoiceType#>' ><img src="../../App_Images/Post.gif" style="border-style: none"/> </a>--%>
</td>
   <td class="GridViewLabItemStyle" style="text-align:center;">
    <img id="Img2" alt="" src="../../App_Images/Post.gif" style="cursor:pointer;" onclick="imgReport(this);" title="Click to View Report"/>
 <a target="_blank"  href='InvoiceReceiptPdf.aspx?InvoiceNo=<#=objRow.InvoiceNo#>' ><img src="../../App_Images/pdf.png" style="border-style: none;width:25px;height:25px;"/> </a>
</td>
<td class="GridViewLabItemStyle" style="text-align:center;display:none"> 
 <a target="_blank"  href='InvoiceReceipt.aspx?InvoiceNo=<#=objRow.InvoiceNo#>&IsDownload=1&Type=<#=objRow.InvoiceType#>' ><img alt="" src="../../App_Images/pdf.png" style="border-style: none;width:25px;height:20px;"/> </a>
</td> 
<# if(<%=UserInfo.RoleID %>==1 && <%=UserInfo.RoleID %>==177 && <%=UserInfo.RoleID %>==6) {#>
      <td class="GridViewLabItemStyle" style="text-align:center;">
                           <img id="Img1" src="../../App_Images/EmailICON.png" alt="" style="cursor:pointer;width:20px;height:20px;" onclick="EmailIt(this);"/> 
                        </td>       <#}#>                 
        <td id="tdPanelID"  class="GridViewLabItemStyle" style=" display:none"><#=objRow.PanelID#></td> 
                        <td id="tdInvoiceEmailTo"  class="GridViewLabItemStyle" style=" display:none"><#=objRow.InvoiceEmailTo#></td> 
                        <td id="tdInvoiceEmailCC"  class="GridViewLabItemStyle" style=" display:none"><#=objRow.InvoiceEmailCC#></td>  
                        <td class="GridViewLabItemStyle" style="text-align:center;display:none;">
	<img id="Img3" src="../../App_Images/view.GIF" style="cursor:pointer;display:none;" />
 <a target="_blank"  href='InvoiceReport.aspx?PanelId=<#=objRow.Panel_ID#>' ><img src="../../App_Images/Post.gif" style="border-style: none"/> </a>
</td>                                
</tr>
            <#}#>
     </table>   
     
     <%-- Invoice Type Popup --%>
     <div id="InvoiceTypeModal" style="display:none;">
         <div style="position:fixed;height:100%;width:100%;background-color:#000;opacity:0.7;z-index:9999;top:0;left:0;"></div>
         <div style="    background-color: #fff;
    padding: 40px;
    position: fixed;
    top: 15%;
    left: 40%;
    height: 85px;
    width: 250px;
    text-align: center;
    Z-INDEX: 99999;
    border: 1px solid #ccc;
    box-shadow:2px 2px 14px #ccc ">
             <input id="hdnPanelId" type="hidden" />
             <input id="hdnInvoiceNo" type="hidden" />
             <input id="hdnInvoiceType" type="hidden" />

             <asp:RadioButtonList runat="server" ID="rdoInvoiceType" RepeatColumns="2" RepeatDirection="Horizontal" style="margin-left: 40px;font-weight:600;">
                 <asp:ListItem Text="Default" Value="1" Selected="True"></asp:ListItem>
                 <asp:ListItem Text="Corporate" Value="2"></asp:ListItem>
             </asp:RadioButtonList>
             <br />
             <input type="button" value="Submit" style="background-color: #09f;
    padding: 10px;
    color: #fff;
    border: 1px solid blue;" onclick="ViewInvoice();" />
             <input type="button" value="Close" style="background-color: orange;
    padding: 10px;
    color: #fff;
    border: 1px solid red;" onclick="CloseViewInvoice();" />

         </div>
     </div>
       
    </script>     
    
          <script type="text/javascript">
              function bindState() {
                  jQuery("#ddlState option").remove();

                  jQuery('#ddlState').trigger('chosen:updated');
                  jQuery('#<%=lstPanel.ClientID%> option').remove();
                  jQuery('#lstPanel').multipleSelect("refresh");
                  if (jQuery("#ddlState").val() != 0)
                      CommonServices.bindState(0,jQuery("#ddlBusinessZone").val(), onSucessState, onFailureState);
              }
              function onSucessState(result) {
                  var stateData = jQuery.parseJSON(result);
                  jQuery("#ddlState").append(jQuery("<option></option>").val("0").html("Select"));
                  if (stateData.length > 0) {
                      jQuery("#ddlState").append(jQuery("<option></option>").val("-1").html("All"));
                  }
                  for (i = 0; i < stateData.length; i++) {
                      jQuery("#ddlState").append(jQuery("<option></option>").val(stateData[i].ID).html(stateData[i].State));
                  }
                  jQuery('#ddlState').trigger('chosen:updated');
              }
              function onFailureState() {

              }

              function bindPanel() {
                  var StateID = jQuery("#ddlState").val() == null ? 0 : jQuery("#ddlState").val();
                  serverCall('InvoiceReprint.aspx/bindPanel', { BusinessZoneID: jQuery("#ddlBusinessZone").val(), StateID: StateID, SearchType: jQuery("#rblSearchType input[type=radio]:checked").val(), PaymentMode: "", TagBusinessLab: "", PanelGroup: 2, IsInvoicePanel: 0, BillingCycle: jQuery("#rblSearchType input[type=radio]:checked").next('label').text(), BusinessUnitID: jQuery('#lstcentre').multipleSelect("getSelects").join() }, function (response) {
                      onSuccessPanel(response);
                  });
              }
              function onSuccessPanel(result) {
                  var panelData = jQuery.parseJSON(result);
                  jQuery('#<%=lstPanel.ClientID%> option').remove();
            jQuery('#lstPanel').multipleSelect("refresh");
            if (panelData != null) {
                if (panelData.length == 0) {
                    jQuery("#lstPanel").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                }

                if (panelData.length > 0) {
                    for (i = 0; i < panelData.length; i++) {
                        jQuery('#<%=lstPanel.ClientID%>').append(jQuery("<option></option>").val(panelData[i].Panel_ID).html(panelData[i].Company_Name));
                }
                jQuery('[id*=lstPanel]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
                if (panelData.length == 1)
                    jQuery('[id*=lstPanel]').multipleSelect("checkAll");
            }
        }
        jQuery('#lstPanel').multipleSelect("refresh");
    }
    function OnfailurePanel() {

    }
    </script>
    <script type="text/javascript">
        jQuery(function () {
            bindPanel();
            jQuery("#btnReport").click(Report);
        });
        var InvoiceData = "";
        function $searchInvoice() {
            var PanelID = "";
            if (jQuery("#hdPanelID").val() != "" && jQuery("#txtPanelName").val() != "") {
                PanelID = jQuery("#hdPanelID").val().split('#')[0];
            }
            else {
                PanelID = jQuery('#lstPanel').multipleSelect("getSelects").join();
            }
            if (jQuery.trim(jQuery("#<%=txtInvoice.ClientID %>").val()) == "" && PanelID == "") {
                toast("Error",'Please Select Client',"");
                return;
            }            
            
             serverCall('InvoiceReprint.aspx/SearchStatus', { DateType: $("#ddlDateType").val(), dtFrom: $("#dtFrom").val(), dtTo: $("#dtTo").val(), PanelID: PanelID, InvoiceNo: $("#txtInvoice").val(),PrintInvoiceReport:0 }, function (response) {
                InvoiceData = jQuery.parseJSON(response);

                if (InvoiceData != null) {
                    var output = jQuery('#tb_InvestigationItems').parseTemplate(InvoiceData);
                    jQuery('#div_Data').html(output);
                    jQuery('#div_Data').show();
                    jQuery('#tb_grdLabSearch').tableHeadFixer({
                    });
                }
                else {
                    jQuery('#div_Data').html('');
                    jQuery('#div_Data').hide();
                    toast("Error", 'No Record Found', "");
                }

            });
        };
        
</script> 
  <script type="text/javascript">
      function Report() {
          jQuery("#tb_grdLabSearch tr").find("#chk").filter(':checked').each(function () {
              var id = jQuery(this).closest("tr").attr("id");
              var $rowid = jQuery(this).closest("tr");
              var PanelID = jQuery('#lstPanel').multipleSelect("getSelects").join();
              window.open('InvoiceReport.aspx?PanelID=' + PanelID + '&InvoiceNo=' + id + '&ReportType=' + jQuery("input:radio[.rad]:checked").val());
          });
      }
      var InvoiceData = "";
      function searchInvoiceSummary() {
          jQuery("#lblMsg").text('');
          var _CentreID = "";
          $('#<%=lstcentre.ClientID%> :selected').each(function (i, selected) {
			    if (_CentreID == "") {
			        _CentreID = $(selected).val();
			    }
			    else {
			        _CentreID = _CentreID + "," + $(selected).val();
			    }
			});
			var _PanelID = "";
			$('#<%=lstPanel.ClientID%> :selected').each(function (i, selected) {
			    if (_PanelID == "") {
			        _PanelID = $(selected).val().split('#')[0];
			    }
			    else {
			        _PanelID = _PanelID + "," + $(selected).val().split('#')[0];
			    }
			});
			jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });

			jQuery.ajax({
			    url: "InvoiceReprint.aspx/SearchInvoiceSummary",
			    data: '{DateType:"' + $("#<%=ddlDateType.ClientID %>").val() + '",dtFrom:"' + $("#<%=dtFrom.ClientID %>").val() + '",dtTo:"' + $("#<%=dtTo.ClientID %>").val() + '",PanelID: "' + _PanelID + '",CentreID: "' + _CentreID + '",InvoiceNo: "' + $("#<%=txtInvoice.ClientID %>").val() + '", paymentMode:"' + $("#ctl00_ContentPlaceHolder1_ddlPaymentMode").val() + '"}', // parameter map 
				type: "POST",
				contentType: "application/json; charset=utf-8",
				timeout: 120000,
				dataType: "json",
				success: function (result) {
				    result = result.d;
				    if (result == "1") {
				        $.unblockUI();
				        window.open('../Common/ExportToExcel.aspx');
				    }
				    else if (result == "-1") {
				        $.unblockUI();
				        toast("Info","Your Session Expired... Please Login Again");
				    } else if (result == "0") {
				        $.unblockUI();
				        toast("Info", "Result Not Found");
				    } else {
				        $.unblockUI();
				        toast("Info", "Try Again Later");
				    }

				},
				error: function (xhr, status) {
				    jQuery.unblockUI();
				}
			});
        };
        function cancelinvoice() {
            try {
                jQuery("#lblMsg").text('');
                var _CentreID = "";
                $('#<%=lstcentre.ClientID%> :selected').each(function (i, selected) {
			       if (_CentreID == "") {
			           _CentreID = $(selected).val();
			       }
			       else {
			           _CentreID = _CentreID + "," + $(selected).val();
			       }
			   });
			   var _PanelID = "";
			   $('#<%=lstPanel.ClientID%> :selected').each(function (i, selected) {
				    if (_PanelID == "") {
				        _PanelID = $(selected).val().split('#')[0];
				    }
				    else {
				        _PanelID = _PanelID + "," + $(selected).val().split('#')[0];
				    }
				});
				jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });

				jQuery.ajax({
				    url: "InvoiceReprint.aspx/cancelinvoice",
				    data: '{DateType:"' + $("#<%=ddlDateType.ClientID %>").val() + '",dtFrom:"' + $("#<%=dtFrom.ClientID %>").val() + '",dtTo:"' + $("#<%=dtTo.ClientID %>").val() + '",PanelID: "' + _PanelID + '",CentreID: "' + _CentreID + '",InvoiceNo: "' + $("#<%=txtInvoice.ClientID %>").val() + '" , paymentMode:"' + $("#ctl00_ContentPlaceHolder1_ddlPaymentMode").val() + '"}', // parameter map 
					type: "POST",
					contentType: "application/json; charset=utf-8",
					timeout: 120000,
					dataType: "json",
					success: function (result) {
					    result = result.d;
					    if (result == "1") {
					        $.unblockUI();
					        window.open('../Common/ExportToExcel.aspx');
					    }
					    else if (result == "-1") {
					        $.unblockUI();
					        toast("Info", "Your Session Expired... Please Login Again");
					    } else if (result == "0") {
					        $.unblockUI();
					        toast("Info", "Result Not Found");
					    } else {
					        $.unblockUI();
					        toast("Info", "Try Again Later");
					    }

					},
					error: function (xhr, status) {
					    jQuery.unblockUI();
					}
				});
            } catch (e) {
                $.unblockUI();
            }
        };
  </script>
<script type="text/javascript">
    jQuery(function () {
        jQuery("#tb_grdLabSearch :text").hide();
    });
    var InvoiceConcat = "";
    function ckhall() {
        if (jQuery("#chkheader").prop(':checked'))
            jQuery("#tb_grdLabSearch :checkbox").prop('checked', 'checked');
        else
            jQuery("#tb_grdLabSearch :checkbox").prop('checked', false);
    }
    function ReportOpen() {
        var Type = jQuery("#<%=rdoReport.ClientID %> input[type=radio]:checked").val();
    }

    function ViewInvoice() {
        var PanelID = $('#hdnPanelId').val();
        var InvoiceNo = $('#hdnInvoiceNo').val();
        var InvoiceType = $('#hdnInvoiceType').val();
        PageMethods.encryptInvoice(InvoiceNo, InvoiceType, PanelID, "", 0, onSucessEncrypt, onFailureEncrypt, "".concat(PanelID, "#$", InvoiceNo, "#$", InvoiceType));

    }
    function CloseViewInvoice() {
        $('#InvoiceTypeModal').fadeOut();
        $('[id$=rdoInvoiceType] input[value=1]').prop('checked', true);

    }

    function ReportPopUp(rowID) {
        //  $find('mpreport').show();
        //   jQuery("#txtInvoiceNo").val(jQuery(rowID).closest('tr').find('#tdInvoiceNo').text());

        var PanelID = jQuery(rowID).closest('tr').find('#tdPanelID').text();
        var InvoiceNo = jQuery(rowID).closest('tr').find('#tdInvoiceNo').text();
        var InvoiceType = jQuery(rowID).closest('tr').find('#tdInvoiceType').text();

        $('#hdnPanelId').val(PanelID);
        $('#hdnInvoiceNo').val(InvoiceNo);
        $('#hdnInvoiceType').val(InvoiceType);

       // $('#InvoiceTypeModal').fadeIn();

         PageMethods.encryptInvoice(InvoiceNo, InvoiceType, PanelID, "", 0, onSucessEncrypt, onFailureEncrypt, "".concat(PanelID, "#$", InvoiceNo, "#$", InvoiceType));


    }
    function onSucessEncrypt(result, InvoiceData) {
        var result1 = jQuery.parseJSON(result);
        if (result1 == "5") {
            toast("Error", 'Please Enter Valid Password');
        }
        else if (result1 == "8") {
            confirmationBox(InvoiceData, "Invoice");
        }
        else {
            window.open('InvoiceReceipt.aspx?InvoiceNo=' + result1[0] + '&Type=' + result1[1] + '&Inc=' + result1[2] + '&View=' + $('[id$=rdoInvoiceType] input:checked').val() + '');
           // CloseViewInvoice();
        }
    }
    function onFailureEncrypt(result) {

    }
</script>
           
    <script type="text/javascript">
        function EmailIt(rowID) {
            jQuery("#<%=lbInvoiceNo.ClientID%>").text(jQuery(rowID).closest('tr').find('#tdInvoiceNo').text());
            jQuery("#<%=lblInvoiceType.ClientID%>").text(jQuery(rowID).closest('tr').find('#tdInvoiceType').text());
            jQuery("#<%=txtEmailID.ClientID%>").val(jQuery(rowID).closest('tr').find('#tdInvoiceEmailTo').text());
            jQuery("#<%=txtEmailCcAddress.ClientID%>").val(jQuery(rowID).closest('tr').find('#tdInvoiceEmailCC').text());
            jQuery("#btnSendMail").removeAttr('disabled').val('Send Mail');
            $find('mpEmail').show();
        }
        function sendMail() {

            if (jQuery('#<%=txtEmailID.ClientID%>').val() == "") {
                alert("Please Enter EmailID");
                jQuery('#<%=txtEmailID.ClientID%>').focus();
                return;
            }
            jQuery("#btnSendMail").attr('disabled', 'disabled').val('Submitting...');
            serverCall('InvoiceReprint.aspx/EmailReport', { InvoiceNo: jQuery('#<%=lbInvoiceNo.ClientID%>').text(), emailID: jQuery('#<%=txtEmailID.ClientID%>').val(), emailCCID: jQuery("#<%=txtEmailCcAddress.ClientID%>").val(), InvoiceType: jQuery("#<%=lblInvoiceType.ClientID%>").text() }, function (response) {

                if (response == "0") {
                    toast("Error", "Email Not Send");
                }
                else {
                    toast("Success", "Email Send");
                    $searchInvoice();
                }
                jQuery("#btnSendMail").removeAttr('disabled').val('Send Mail');
                $find('<%=mpEmail.ClientID%>').hide();
                jQuery("#btnSave").removeAttr('disabled').val('Send Mail');
            });
            
        }
        
    </script>
    <script type="text/javascript">
        function clearControl() {
            jQuery('#ddlBusinessZone').prop('selectedIndex', 0);
            jQuery('#ddlBusinessZone').trigger('chosen:updated');
           // jQuery('#ddlState').empty();
            jQuery('#ddlState').trigger('chosen:updated');
            jQuery('#<%=lstPanel.ClientID%> option').remove();
            jQuery('#lstPanel').multipleSelect("refresh");
            jQuery('#div_Data').html('');
            jQuery('#div_Data').hide();
            if ($("#lblSearchType").text() == "2")
                Panel_Invoice.SalesChildNode(jQuery("#rblSearchType input[type=radio]:checked").val(),2, onSuccessPanel, OnfailurePanel);
            else if ($("#lblSearchType").text() == "3")
                Panel_Invoice.SalesCentreAccess(2,onSuccessPanel, OnfailurePanel);
        }
        
    </script>
    <script type="text/javascript">
        function imgReport(rowID) {
            var PanelID = jQuery(rowID).closest('tr').find('#tdPanelID').text();
            var InvoiceNo = jQuery(rowID).closest('tr').find('#tdInvoiceNo').text();
            serverCall('InvoiceReprint.aspx/CollectionReport', { InvoiceNo: InvoiceNo, PanelID: PanelID,IsPassword:0,password:"" }, function (response) {
                if (response == 1) {
                    window.open('../common/ExportToExcel.aspx');
                }
                else if (response == "5") {
                    toast("Error", 'Please Enter Valid Password', "");
                }
                else if (response == "8") {
                    confirmationBox("".concat(PanelID, "#$", InvoiceNo), "Report");
                }
                else {
                    toast('Error','Error','');
                }
            });            
        }
        
    </script>
    <script type="text/javascript">
        jQuery(function () {
            jQuery('#txtPanelName').bind("keydown", function (event) {
                if (event.keyCode === jQuery.ui.keyCode.TAB &&
                    $(this).autocomplete("instance").menu.active) {
                    event.preventDefault();
                }
                jQuery("#hdPanelID").val('');
            })
              .autocomplete({
                  autoFocus: true,
                  source: function (request, response) {
                      jQuery.getJSON("../Common/CommonJsonData.aspx?cmd=LedgerPanel", {
                          SearchType: jQuery("#rblSearchType input[type=radio]:checked").val(),
                          PanelName: request.term,
                          IsInvoicePanel:2
                      }, response);
                  },
                  search: function () {
                      // custom minLength                    
                      var term = this.value;
                      if (term.length < 2) {
                          return false;
                      }
                  },
                  focus: function () {
                      // prevent value inserted on focus
                      return false;
                  },
                  select: function (event, ui) {
                      jQuery("#hdPanelID").val(ui.item.value);
                      this.value = ui.item.label;
                      return false;
                  },
              });
        });
        function showAccountSearch() {
            jQuery(".trType,#tblType").show();
        }
        function hideSearchCriteria1() {
            jQuery(".trType,#tblType").hide();

        }
        function hideSearchCriteria() {
            jQuery("#tblType").show();
            jQuery(".trType").hide();

        }
        $(function () {
           //if ($("#lblSearchType").text() == "2")
           //    Panel_Invoice.SalesChildNode(jQuery("#rblSearchType input[type=radio]:checked").val(),2, onSuccessPanel, OnfailurePanel);
           //else if ($("#lblSearchType").text() == "3")
           //    Panel_Invoice.SalesCentreAccess(2,onSuccessPanel, OnfailurePanel);
        });
    </script>
    <script type="text/javascript">
        function confirmationBox(InvoiceData, ReportType) {
            jQuery.confirm({
                title: 'Confirmation!',
                useBootstrap: false,
                closeIcon: true,
                columnClass: 'small',
                type: 'red',
                typeAnimated: true,
                animationBounce: 2,
                autoClose: 'cancel|20000',
                content: '' +
        '<form action="" class="formName" >' +
        '<div class="form-group" >' +
        '<label>Enter Password :&nbsp;</label>' +
        '<input type="password" placeholder="Password" class="name form-control" required />' +
        '</div>' +
        '</form>',
                buttons: {
                    formSubmit: {
                        text: 'Submit',
                        btnClass: 'btn-blue',
                        useBootstrap: false,
                        type: 'red',
                        typeAnimated: true,
                        autoClose: 'cancel|10000',
                        action: function () {

                            var name = this.$content.find('.name').val();
                            if (!name) {
                                alert('Please enter password');
                                this.$content.find('.name').focus();
                                return false;
                            }
                            if (ReportType == "Report")
                                PageMethods.CollectionReport(InvoiceData.split('#$')[1], InvoiceData.split('#$')[0], 1, name, onSucessCollectionReport, onFailureReport, "".concat(InvoiceData.split('#$')[0], "#$", InvoiceData.split('#$')[1]));
                            else
                                PageMethods.encryptInvoice(InvoiceData.split('#$')[1], InvoiceData.split('#$')[2], InvoiceData.split('#$')[0], name, 1, onSucessEncrypt, onFailureEncrypt, "".concat(InvoiceData.split('#$')[0], "#$", InvoiceData.split('#$')[1], "#$", InvoiceData.split('#$')[2]));

                        }
                    },
                    cancel: function () {
                        //close
                    },

                },
                onContentReady: function () {
                    // bind to events
                    var jc = this;
                    this.$content.find('form').on('submit', function (e) {
                        // if the user submits the form by pressing enter in the field.
                        e.preventDefault();
                        jc.$$formSubmit.trigger('click'); // reference the button and click it
                    });
                }
            });
        }
    </script>
</asp:Content>