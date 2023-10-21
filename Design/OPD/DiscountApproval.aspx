<%@ Page  Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="DiscountApproval.aspx.cs" Inherits="Design_OPD_DiscountApproval" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content2" runat="server">
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
       <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
          <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/App_Style/css" />

       <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
       <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
     <script type="text/javascript" src="~/Scripts/jquery-3.1.1.min.js" ></script>
     <script type="text/javascript" src="~/Scripts/chosen.jquery.js" ></script>
      <script type="text/javascript" src="~/Scripts/Common.js" ></script>
     <link href="../../App_Style/multiple-select.css" rel="stylesheet"/>
    <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css"/>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 
    <script src="../../Scripts/jquery-confirm.min.js" type="text/javascript"></script>
    <%--<%: Scripts.Render("~/bundles/MsAjaxJs") %>--%>
    <style type="text/css">
    .multiselect {
        width: 100%;
    }
</style>
    <script type="text/javascript">

        jQuery(function () {
            jQuery('[id*=ddlappby]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
               
        });


         </script>
    <div id="Pbody_box_inventory" style="width:1304px;">
         <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;width:1300px;">


            <b>Discount Approval</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />

           
        </div>
        <div  class="POuter_Box_Inventory" style="width:1300px;">
   <div class="Purchaseheader">
                Search
            </div>

            <table  style="border-collapse:collapse;width:100%">
                <tr>
                      <td style="text-align: right"><b>From Date :&nbsp;</b></td>
                      <td>  <asp:TextBox ID="txtFromDate" runat="server" Width="110px" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender></td>
                      <td style="text-align: right"><b>To Date :&nbsp;</b></td>
                      <td> <asp:TextBox ID="txtToDate" runat="server" Width="110px" />
                        <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender></td>
                </tr>

                <tr>
                    <td style="text-align: right"><b>Visit No. :&nbsp;</b></td>

                    <td><asp:TextBox ID="txtvisitno"  runat="server" MaxLength="15"></asp:TextBox></td>
                      <td style="text-align: right"><b>Patient Name :&nbsp;</b></td>
                      <td><asp:TextBox ID="txtpname"  runat="server" MaxLength="200"></asp:TextBox></td>

                </tr>

                <tr>
                    <td style="text-align: right; font-weight: 700;">Booking Centre :&nbsp;</td>
                    <td colspan="3"><asp:DropDownList ID="ddlcentre" class="ddlcentre  chosen-select" runat="server" Width="350"></asp:DropDownList></td>
                     
                </tr>

                <tr>
                    <td style="text-align: right; font-weight: 700;">Discount Approved By :&nbsp;</td>
                    <td colspan="3">
                        <asp:ListBox ID="ddlappby" runat="server" CssClass="multiselect" SelectionMode="Multiple" Width="350"></asp:ListBox> 
                        <%--<asp:DropDownList ID="ddlappby" CssClass="multiselect" runat="server"></asp:DropDownList>--%>

                    </td>
                     
                </tr>

                <tr>
                    <td style="text-align: center" colspan="4"><input type="button" value="Search" class="searchbutton" onclick="searchDisc()" />
                        <input type="button" value="Approve" class="searchbutton" onclick="updateDiscount('','1')" />
                        <input type="button" value="Reject" class="searchbutton" onclick="updateDiscount('','-1')" />
                    </td>
                </tr>
            </table>
        </div>

         <div class="POuter_Box_Inventory" style="text-align: center;display:none;width:1300px;" id="div_DiscountOutput">
             <div class="Purchaseheader">
                Pending Approval/Reject
            </div>
            <table  style="width: 100%; border-collapse:collapse" >
                <tr >
                    <td colspan="4">
                        <div id="DiscountSearchOutput" style="max-height: 500px; overflow-x: auto;">
                        </div>
                                              
                    </td>
                </tr>
            </table>
</div>
        <div class="POuter_Box_Inventory" style="text-align: center;display:none;width:1300px;" id="div_DisOutput">
            <div class="Purchaseheader">
                Current Month Details
            </div>
             <table style="width: 100%;border-collapse:collapse">
                            
                 <tr>
                      <td style="width:40%">
                                    &nbsp;
                                </td>
                                <td style="border: thin solid black;background-color: lightgreen;width:2%;height:6%; text-align:right"></td>
                                <td style=" height: 8px;text-align:left">Approved&nbsp;
                                </td>
                                  <td style="border: thin solid black; background-color:coral;width:2%;height:6%;text-align:right" ></td>
                                <td style=" height: 8px;text-align:left">Reject&nbsp;</td>
                        <td style="width:40%">
                                    &nbsp;
                                </td>
                 </tr>
                                 </table>

            <table  style="width: 100%; border-collapse:collapse" >
                <tr >
                    <td colspan="4">
                        <div id="DisSearchOutput" style="max-height: 500px; overflow-x: auto;">
                        </div>
                                              
                    </td>
                </tr>
            </table>
             </div> 


    </div>
    <script id="tb_DiscountSearch" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdSearch"
    style="width:980px;border-collapse:collapse;">
		<tr id="Header">
			
            <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Booking Centre</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Visitno</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Barcodeno</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:240px;">Patient Name</th>     
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Gender</th>  
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Gross Amt.</th>    
            <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">LedgerTransactionID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Discount Amt.</th>  
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Net Amt.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Dis Reason</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Remarks</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">CreatedBy</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:10px;">
               <input type="checkbox" class="chkAll"  onclick="chkAll(this)"  />
			</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;display:none;"></th>  
            <th class="GridViewHeaderStyle" scope="col" style="width:120px;display:none;"></th>                     
		</tr>
        <#
        var dataLength=DiscountData.length;
        var objRow;
        for(var j=0;j<dataLength;j++)
        {
        objRow = DiscountData[j];
        #>
                    <tr id="<#=objRow.LedgerTransactionID#>">
                  

                   <td class="GridViewLabItemStyle" id="tdBookingCentre" style="text-align:left"><#=objRow.BookingCentre#></td>
                        <td class="GridViewLabItemStyle" id="tdvisitno" style="text-align:left"><#=objRow.Labno#></td>
                        <td class="GridViewLabItemStyle" id="tdsinno" style="text-align:left"><#=objRow.Barcodeno#></td>
                        <td class="GridViewLabItemStyle" id="tdDate" style="width:90px;"><#=objRow.DATE#></td>
                        <td class="GridViewLabItemStyle"  style="text-align:left"><#=objRow.PName#></td> 
                         <td class="GridViewLabItemStyle"  style="width:80px;"><#=objRow.Gender#></td> 
                         <td class="GridViewLabItemStyle"  style="width:90px;text-align:right"><#=objRow.GrossAmount#></td>     
                         <td class="GridViewLabItemStyle" id="tdLedgerTransactionID" style="width:140px;display:none"><#=objRow.LedgerTransactionID#></td>
                         <td class="GridViewLabItemStyle" id="tdDiscountOnTotal" style="width:90px;text-align:right"><#=objRow.DiscountOnTotal#></td>
                        <td class="GridViewLabItemStyle"  style="width:90px;text-align:right"><#=objRow.NetAmount#></td> 
                         <td class="GridViewLabItemStyle"  style="text-align:right"><#=objRow.DisReason#></td>     
                        <td class="GridViewLabItemStyle"  style="text-align:right"><#=objRow.Remarks#></td>     
                         <td class="GridViewLabItemStyle"  style="text-align:right"><#=objRow.CreatedBy#></td>  
                      <td class="GridViewLabItemStyle">
                        <input type="checkbox" id="chkSelect"  onclick="chkSelect(this)" class="chkSelect"  />
                    </td>
                    <td class="GridViewLabItemStyle" id="tdApproved" style="width:120px;display:none;">
                        <input type="button" class="ItDoseButton" id="btnApproved" value="Approved" onclick="disApproved(this)" />
                    </td>
                        <td class="GridViewLabItemStyle" id="tdReject" style="width:120px;display:none;">
                        <input type="button" class="ItDoseButton" id="btnReject" value="Reject" onclick="disReject(this)" />
                    </td>
                    </tr>

        <#}

        #>
        
     </table>
    </script>
    <script id="tb_DiscSearch" type="text/html">
    <table class="FixedTables" cellspacing="0" rules="all" border="1" 
    style="width:980px;border-collapse:collapse;">
		<tr id="Tr1">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Booking Centre</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Visitno</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Barcodeno</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Date</th>             
            <th class="GridViewHeaderStyle" scope="col" style="width:260px;">Patient Name</th>     
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Gender</th>  
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Gross Amt.</th>              
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">Discount Amt.</th>  
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Net Amt.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Dis Reason</th>
			            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Remarks</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">CreatedBy</th>
                            
		</tr>
        <#
        var dataLength=AllDiscData.length;
        var objRow;
        for(var k=0;k<dataLength;k++)
        {
        objRow = AllDiscData[k];
        #>
                     <tr id="<#=objRow.LedgerTransactionID#>"
                         <#if(objRow.IsDiscountApproved=="1"){#>
                          style="background-color:lightgreen"
                         <#} 
                          else if(objRow.IsDiscountApproved =="-1"){#>
                       style="background-color:coral"
                        <#} #>>
                          <td class="GridViewLabItemStyle"><#=k+1#></td>     
                         <td class="GridViewLabItemStyle"  style="text-align:left;"><#=objRow.BookingCentre#></td>   
                         <td class="GridViewLabItemStyle" id="td1" style="text-align:left"><#=objRow.Labno#></td>
                        <td class="GridViewLabItemStyle" id="td2" style="text-align:left"><#=objRow.Barcodeno#></td>          
                         <td class="GridViewLabItemStyle"  style="width:90px;"><#=objRow.DATE#></td> 
                         <td class="GridViewLabItemStyle"  style="text-align:left;"><#=objRow.PName#></td> 
                         <td class="GridViewLabItemStyle"  style="text-align:left"><#=objRow.Gender#></td> 
                         <td class="GridViewLabItemStyle"  style="text-align:right"><#=objRow.GrossAmount#></td>                   
                         <td class="GridViewLabItemStyle"  style="text-align:right"><#=objRow.DiscountOnTotal#></td>
                        <td class="GridViewLabItemStyle"  style="text-align:right"><#=objRow.NetAmount#></td>       
                         <td class="GridViewLabItemStyle"  style="text-align:right"><#=objRow.DisReason#></td>
						   <td class="GridViewLabItemStyle"  style="text-align:right"><#=objRow.Remarks#></td>          
                         <td class="GridViewLabItemStyle"  style="text-align:right"><#=objRow.CreatedBy#></td>     
                    </tr>

        <#}

        #>
        
     </table>
    </script>
      <script type="text/javascript">
          $(function () {
              searchDisc();
              searchAllDisc();
          });
         </script>
    <script type="text/javascript">
        function searchAllDisc() {
            $('#lblMsg').text('');
            var empid = $('#ContentPlaceHolder1_ddlappby').val().toString();
            $.ajax({
                url: "DiscountApproval.aspx/bindAllDisAmt",
                data: '{fromdate:"' + $('#<%=txtFromDate.ClientID%>').val() + '",todate:"' + $('#<%=txtToDate.ClientID%>').val() + '",visitno:"' + $('#<%=txtvisitno.ClientID%>').val() + '",pname:"' + $('#<%=txtpname.ClientID%>').val() + '",centre:"' + $('#<%=ddlcentre.ClientID%>').val() + '",empid:"' + empid + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    AllDiscData = jQuery.parseJSON(result.d);

                    if (AllDiscData != null && AllDiscData != "") {
                        var output = $('#tb_DiscSearch').parseTemplate(AllDiscData);
                        $('#DisSearchOutput').html(output);
                        $('#DisSearchOutput,#div_DisOutput').show();


                    }
                    else {
                        $('#DisSearchOutput').html();
                        $('#DisSearchOutput,#div_DisOutput').hide();
                        $('#lblMsg').text('Record Not Found');

                    }

                }

            });
        }
         </script>

    <script type="text/javascript">
        function searchDisc() {
            $('#lblMsg').text('');
            var empid = $('#ContentPlaceHolder1_ddlappby').val().toString();
            $.ajax({
                url: "DiscountApproval.aspx/bindDisAmt",
                data: '{fromdate:"' + $('#<%=txtFromDate.ClientID%>').val() + '",todate:"' + $('#<%=txtToDate.ClientID%>').val() + '",visitno:"' + $('#<%=txtvisitno.ClientID%>').val() + '",pname:"' + $('#<%=txtpname.ClientID%>').val() + '",centre:"' + $('#<%=ddlcentre.ClientID%>').val() + '",empid:"' + empid + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    DiscountData = jQuery.parseJSON(result.d);

                    if (DiscountData != null && DiscountData != "") {
                        var output = $('#tb_DiscountSearch').parseTemplate(DiscountData);
                        $('#DiscountSearchOutput').html(output);
                        $('#DiscountSearchOutput,#div_DiscountOutput').show();


                    }
                    else {
                        $('#DiscountSearchOutput').html();
                        $('#DiscountSearchOutput,#div_DiscountOutput').hide();
                        $('#lblMsg').text('Record Not Found');

                    }
                    searchAllDisc();
                }

            });
        }
         </script>
    <script type="text/javascript">
        function chkAll(rowID) {
            if ($(".chkAll").is(':checked'))
                $(".chkSelect").prop('checked', 'checked');
            else
                $(".chkSelect").prop('checked', false);
        }
        function chkSelect(rowID) {
            if ($(".chkSelect").length == $(".chkSelect:checked").length)
                $(".chkAll").prop("checked", "checked");
            else
                $(".chkAll").prop('checked', false);

        }
    </script>
    <script type="text/javascript">
        
        function disReject(rowID) {          
            updateDiscount($(rowID).closest('tr').find('#tdLedgerTransactionID').text(), "-1");
        }
        function disApproved(rowID) {           
            updateDiscount($(rowID).closest('tr').find('#tdLedgerTransactionID').text(), "1");
        }
        function updateDiscount(LedgerTransactionID, IsDiscountApproved) {
            var LabID = '';
            $("#tb_grdSearch tr").find("#chkSelect").filter(':checked').each(function () {
                LabID = LabID == '' ? $(this).closest('tr').attr('id') : LabID + ',' + $(this).closest('tr').attr('id');
              });

            $.ajax({
                url: "DiscountApproval.aspx/updateDiscApproved",
                data: '{LedgerTransactionID:"' + LabID + '",IsDiscountApproved:"' + IsDiscountApproved + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    if (result.d == "2") {
                        alert('Record Saved Successfully');
                        
                    }
                    else if (result.d == "0") {
                        alert('Error..');
                        $('.ItDoseButton').removeAttr('disabled');
                        return;
                    }
                    else if (result.d == "1") {
                        alert('Already Approved Discount');
                    }

                    else if (result.d == "-1") {
                        alert('Already Reject Discount');
                    }
                    searchDisc();
                    searchAllDisc();
                    $('.ItDoseButton').removeAttr('disabled');
                }

            });
        }
       
    </script>
</asp:Content>


