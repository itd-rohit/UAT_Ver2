<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true"  CodeFile="OnlinePaymentStatus.aspx.cs" Inherits="Design_Master_OnlinePaymentStatus" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
	Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
	<script src="../../JavaScript/jquery-1.7.1.min.js" type="text/javascript"></script>
	<script src="../../JavaScript/jquery.extensions.js" type="text/javascript"></script>
	<script type="text/javascript" src="../../JavaScript/jquery.blockUI.js"></script>
	<link href="../../combo-select-master/chosen.css" rel="stylesheet" type="text/css" />
	<script src="../../combo-select-master/chosen.jquery.js" type="text/javascript"></script>
	<Ajax:ScriptManager AsyncPostBackErrorMessage="Error..." ID="ScriptManager2" runat="server">
		<Services>
			<Ajax:ServiceReference Path="~/Lis.asmx" />
		</Services>
	</Ajax:ScriptManager>
	<div class="alert fade" style="position: absolute; left: 30%; border-radius: 15px; z-index: 11111; text-align: center">
		<p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
	</div>
  

    <div id="body_box_inventory" style="width: 97%;">

		<div class="Outer_Box_Inventory" style="width: 99.6%;">
			<div class="Purchaseheader">Payment Status Details  <asp:Label ID="lblErrorMsg" runat="server" class="ItDoseLblError"></asp:Label>&nbsp;</div> 
            
             <table id="Table1" style="width: 100%; margin: 0 auto; border-collapse: collapse">
                    <tr>
                        <td style="text-align: left;font-weight:bold;color:red;">Company :</td>
                        <td style="text-align: left;">
                            <asp:DropDownList ID="ddlCompany" runat="server" Width="200px" CssClass="ddlCompany chosen-select"></asp:DropDownList>
                        </td>
                         <td style="text-align: left;font-weight:bold;color:red;">From Date :</td>
                           <td style="text-align:left"><asp:TextBox ID="txtFromDate" runat="server" Width="200px" ></asp:TextBox>
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" PopupButtonID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                   </td>
                         <td style="text-align: left;font-weight:bold;color:red;">To Date :</td>
                          <td style="text-align:left">
                         <asp:TextBox ID="txtToDate" runat="server" Width="200px" ></asp:TextBox>
                 <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" PopupButtonID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                     </td>
                        </tr>
                 <tr>
                        <td style="text-align: left;font-weight:bold;color:red;">Amount :</td>
                        <td style="text-align: left;">
                            <asp:TextBox ID="txtAmount" runat="server" Width="200px" ></asp:TextBox>
                        </td>
                         <td style="text-align: left;font-weight:bold;"></td>
                           <td style="text-align: left;">
                               
                       </td>
                         <td style="text-align: left;font-weight:bold;"></td>
                          <td style="text-align:left">
                            
                     </td>
                        </tr>
                    
                 </table>
       </div> 
         <div class="POuter_Box_Inventory" style="width: 99.6%; text-align: center;">
            <button type="button" id="btnSearch" onclick="Search('')" class="searchbutton" style="width:150px;">Search</button>
              <button type="button" id="btnExport" onclick="ExportExcelFromTable()" class="resetbutton" style="width:150px;">Export to Excel</button>
             <div id="colorindication" runat="server">
                    <table width="60%" style="margin-left:20%">
                        <tr>
                               <td style="cursor:pointer;width:50px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:white;"
                                onclick="Search(' and mtb.IsSuccess=2 ')">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                               Pending</td>
                        <td style="cursor:pointer;width:50px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:#CC99FF;"
                                onclick="Search(' and mtb.IsSuccess=0 ')">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                               Failed</td>
                           
                               <td style="cursor:pointer;width:50px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color:#90EE90;"
                                onclick="Search(' and mtb.IsSuccess=1 ')">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                            <td>
                               Success</td>                          
                                                
                               
                               
                        </tr>
                    </table>
                </div>
        </div>
          <div class="POuter_Box_Inventory" style="width:99.6%; text-align: center;">
               <div class="content">
                    <div class="Purchaseheader">
                        <table width="80%">
                            <tr>
                                <td>Payment Search </td>

                                <td>Search :&nbsp;&nbsp;<input type="text" id="txtsearchbyname" placeholder="Type Text To Search" />
                                </td>



                            </tr>
                        </table>
                    </div>
                </div>
           <div id="divInterface" style="max-height: 320px; overflow-y: auto; overflow-x: hidden;">
                                        
                                        </div>
                </div>
        </div>
   

    <script type="text/javascript">

        function Search(_SearchType) {
            var _InterfaceCompany = $('#<%=ddlCompany.ClientID%>').val();
            if (_InterfaceCompany == "Select") {
                _InterfaceCompany = "";
            }
            if (_InterfaceCompany == "0") {
                _InterfaceCompany = "";
            }
            $('#divInterface').html('');
            $('#divInterface').hide();
            $('#<%=lblErrorMsg.ClientID%>').text('');
            $('#btnSearch').attr('disabled', 'disabled').val('Searching...');
            $.blockUI();
            jQuery.ajax({
                url: "OnlinePaymentStatus.aspx/Search",
                data: '{CompanyID:"' + _InterfaceCompany + '", dtFrom:"' + $('#<%=txtFromDate.ClientID%>').val() + '",dtTo:"' + $('#<%=txtToDate.ClientID%>').val() + '",Amount:"' + $('#<%=txtAmount.ClientID%>').val() + '",SearchType:"' + _SearchType + '"}',
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    InterfaceData = eval('[' + result + ']');
                    if (InterfaceData.length == 0) {
                        $('#divInterface').html('');
                        $('#divInterface').hide();
                        $.unblockUI();
                    }
                    else {

                        var output = $('#tb_Interface').parseTemplate(InterfaceData);
                        $('#divInterface').html(output);
                        $('#divInterface').show();
                        $.unblockUI();
                    }
                    $('#btnSearch').removeAttr('disabled').val('Search');
                    $.unblockUI();
                },
                error: function (xhr, status) {
                    $('#btnSearch').removeAttr('disabled').val('Search');
                    $.unblockUI();
                }
            });
        }
        function hideTable() {
            $('#<%=lblErrorMsg.ClientID%>').text('');
            $('#divInterface').html('');
            $('#divInterface').hide();
        }

        function ResendData(rowID) {
            jQuery(rowID).closest('tr').find("#btnResend").val('Resending...').attr('disabled', 'disabled');

            var ID = $(rowID).closest('tr').find('#tdID').text();
            //alert(ID);
            jQuery.ajax({
                url: "OnlinePaymentStatus.aspx/resendUpdateRequst",
                data: '{ ID:"' + ID + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    resendData = result;
                    if (resendData == "1") {
                        $('#<%=lblErrorMsg.ClientID%>').text('Resend Successfully');
                        $(rowID).closest('tr').find("#btnResend").hide();
                        $(rowID).closest('tr').find("#btnResend").val('Resend').removeAttr('disabled');
                        Search('');
                    }
                    else {
                        $('#<%=lblErrorMsg.ClientID%>').text('Error to Resend Data');
                    }
                },
                error: function (xhr, status) {
                    jQuery('#btnSearch').removeAttr('disabled').val('Search');
                  
                }
            });

        }
        function ExportExcelFromTable() {
            var tab_text = "<table border='2px'><tr bgcolor='#87AFC6'>";
            var textRange; var j = 0;
            tab = document.getElementById('tb_grdInterface'); // id of table

            for (j = 0 ; j < tab.rows.length ; j++) {
                tab_text = tab_text + tab.rows[j].innerHTML + "</tr>";
                //tab_text=tab_text+"</tr>";
            }

            tab_text = tab_text + "</table>";
            tab_text = tab_text.replace(/<A[^>]*>|<\/A>/g, "");//remove if u want links in your table
            tab_text = tab_text.replace(/<img[^>]*>/gi, ""); // remove if u want images in your table
            tab_text = tab_text.replace(/<input[^>]*>|<\/input>/gi, ""); // reomves input params

            var ua = window.navigator.userAgent;
            var msie = ua.indexOf("MSIE ");

            if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./))      // If Internet Explorer
            {
                txtArea1.document.open("txt/html", "replace");
                txtArea1.document.write(tab_text);
                txtArea1.document.close();
                txtArea1.focus();
                sa = txtArea1.document.execCommand("SaveAs", true, "Say Thanks to Sumit.xls");
            }
            else                 //other browser not tested on IE 11
                sa = window.open('data:application/vnd.ms-excel,' + encodeURIComponent(tab_text));

            return (sa);
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
                jQuery(selector).chosen(config[selector]);
            }

            $('#txtsearchbyname').keyup(function () {
                var value = $(this).val().toLowerCase();
                $("#tb_grdInterface tr:not(:first)").filter(function () {
                    $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
                });

            });
        });
    </script>
    <script id="tb_Interface" type="text/html">
    <table  cellspacing="0" rules="all" border="1" id="tb_grdInterface"
    style="width:1280px;border-collapse:collapse;">
        <thead>
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;"> Panel Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;"> Panel Code</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;"> Payment Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Amount</th>
           
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Order No</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Bank Ref.No</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Updated Date</th>
                    <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Remark</th>
             <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Status</th>           
             <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Resend</th>
           
           
		</tr>
             </thead>
        <#
        var dataLength=InterfaceData.length;
       
        var objRow;           
        for(var j=0;j<dataLength;j++)
        {
        objRow = InterfaceData[j];
        #>
                    <tr id="<#=j+1#>" style="background-color:<#=objRow.rowColor#>;">
                    <td class="GridViewLabItemStyle"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="Td3" style="width:120px;"><#=objRow.PanelName#></td>
                          <td class="GridViewLabItemStyle" id="Td4" style="width:120px;"><#=objRow.Panel_Code#></td>
                         <td class="GridViewLabItemStyle" id="PatientName" style="width:120px;"><#=objRow.EntryDate#></td>
                        <td class="GridViewLabItemStyle" id="PatientID" style="width:60px;"><#=objRow.Amount#></td>
                        <td class="GridViewLabItemStyle" id="RegID" style="width:120px;"><#=objRow.OrderNo#></td>
                    <td class="GridViewLabItemStyle" id="InvestigationID" style="width:120px;"><#=objRow.BankRefNo#></td>
                          <td class="GridViewLabItemStyle" id="Td1" style="width:220px;"><#=objRow.ScheduleEntryDate#></td>
                   <td class="GridViewLabItemStyle" id="td5" style="width:60px;"><#=objRow.Remark#></td> 
                        <td class="GridViewLabItemStyle" id="tdStatus" style="width:60px;"><#=objRow.STATUS#></td> 
                   
                         
 <td class="GridViewLabItemStyle" id="td2" style="width:120px;">
                             <#
                           if(objRow.IsSuccess=="0"){#>
                              <input type="button" id="btnResend" class="ItDoseButton"  value="Resend" onclick="ResendData(this)"/>
                               <#}
                            #>
                           </td>
                         <td class="GridViewLabItemStyle" id="tdID" style="width:120px;display:none"><#=objRow.ID#></td>  
                       
                    </tr>
        <#}
        #>       
     </table>

    </script>
    
    

   
</asp:Content>

