<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="EnrollmentSearch.aspx.cs" Inherits="Design_Sales_EnrollmentSearch" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

     <%: Scripts.Render("~/bundles/MsAjaxJs") %>
       <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111">
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>  
     <div id="Pbody_box_inventory" style="width:1304px;">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server"  EnablePageMethods="true"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;width:1300px;">
            <b>Enrolment Search</b><br />
            <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red" ClientIDMode="Static"></asp:Label>
            <asp:Label ID="lblView" runat="server"  style="display:none" ClientIDMode="Static"></asp:Label>
        </div>
            <div class="POuter_Box_Inventory" style="width:1300px;"> 
            <div class="Purchaseheader">
                Search Criteria
            </div>           
                <table style="width:100%;border-collapse:collapse" >
                    <tr>
                                    <td colspan="4">
                                        &nbsp;&nbsp;
                                    </td>
                                </tr>
                    <tr>
<td style="text-align: right; font-weight: 700;width:30%">From Date :&nbsp;</td>
                        <td style="width:20%">   <asp:TextBox ID="txtFromDate" runat="server" Width="110px" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender></td>
                        <td style="text-align: right; font-weight: 700;width:10%">To Date :&nbsp;&nbsp;</td>
                        <td>
                             <asp:TextBox ID="txtToDate" runat="server" Width="110px" />
                        <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </td>
                    </tr>
                  <tr>
                                    <td colspan="4">
                                        &nbsp;&nbsp;
                                    </td>
                                </tr>
                
                     </table>
                  </div>
    <div class="POuter_Box_Inventory" style="width:1300px;text-align:center"> 
    <input type="button" value="Search" class="searchbutton" onclick="searchenrollment(0)" id="btnSearch" />
        <div>
                    <table  style="width:100%">
                        <tr>
                            <td>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                            <td style="background-color:#C6DFF9;width:50px;border:1px solid black;cursor:pointer;" onclick="searchenrollment('1')"></td>
                                     <td style="text-align:left"><b>Create</b></td>

                                      <td style="background-color:#90EE90;width:50px;border:1px solid black;cursor:pointer;" onclick="searchenrollment('2')"></td>
                                     <td style="text-align:left"><b>Verify</b></td>

                             <td style="background-color:#FFC0CB;width:50px;border:1px solid black;cursor:pointer;" onclick="searchenrollment('3')"></td>
                                     <td style="text-align:left"><b>Approved</b></td>

                                      <td style="background-color:#CC99FF;width:50px;border:1px solid black;cursor:pointer;" onclick="searchenrollment('4')"></td>
                                     <td style="text-align:left"><b>Sales Verified</b></td>

                                      <td style="background-color:#3399FF;width:50px;border:1px solid black;cursor:pointer;" onclick="searchenrollment('5')"></td>
                                     <td style="text-align:left"><b>Financial Verified</b></td>

                             <td style="background-color:#B0C4DE;width:50px;border:1px solid black;cursor:pointer;" onclick="searchenrollment('6')"></td>
                                     <td style="text-align:left"><b>Registered</b></td>

                             <td style="background-color:#FFFFFF;width:50px;border:1px solid black;cursor:pointer;" onclick="searchenrollment('7')"></td>
                                     <td style="text-align:left"><b>DeActive</b></td>
                            <td>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                        </tr>
                    </table>
            </div>        
                    
               
                </div>

          <div class="POuter_Box_Inventory" style="width:1300px;"> 
            <div class="Purchaseheader">
                Enrolment Within Selected Date &nbsp;&nbsp;<span style="color:red;">Total Enrolment : &nbsp;</span><asp:Label ID="lbltotal" ForeColor="Red" runat="server" Text="0"></asp:Label>
            </div>              
               <div id="divEnrolment" style="max-height: 320px; overflow-y: auto; overflow-x: hidden;">                                        
               </div>
              </div>
         </div>
    <script type="text/javascript">
        
        function showerrormsg(msg) {
            jQuery('#msgField').html('');
            jQuery('#msgField').append(msg);
            jQuery(".alert").css('background-color', 'red');
            jQuery(".alert").removeClass("in").show();
            jQuery(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
        function onSucessEnrollSearch(result) {
            Edata = jQuery.parseJSON(result);
            if (Edata.length == 0) {
                showerrormsg('No Enrolment Found..!');
                jQuery('#<%=lbltotal.ClientID%>').text('0');
                jQuery('#divEnrolment').hide();
            }
            else {
                jQuery('#<%=lbltotal.ClientID%>').text(Edata.length);
                var output = jQuery('#tb_Enrolment').parseTemplate(Edata);
                jQuery('#divEnrolment').html(output);
                jQuery('#divEnrolment').show();
            }
            jQuery('#btnSearch').removeAttr('disabled').val('Search');

        }
        function searchenrollment(searchType) {
            jQuery('#btnSearch').attr('disabled', 'disabled').val('Searching...');
            PageMethods.searchEnrollment(jQuery('#<%=txtFromDate.ClientID%>').val(), jQuery('#<%=txtToDate.ClientID%>').val(), searchType, onSucessEnrollSearch, onFailureEnroll);            
        }
    </script>
    <script id="tb_Enrolment" type="text/html">
    <table  cellspacing="0" rules="all" border="1" id="tb_grdEnrolment"
    style="width:1280px;border-collapse:collapse;">
        <thead>
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:30px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;">Type</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:200px;">Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:260px;">Address</th>          
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Min Business Commitment</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Invoice Billing Cycle</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:180px;">Created By</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Created Date</th>
                             
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Approved/Verified</th>          
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;">View</th>    
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;">HLM Report</th>    
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
                        if(objRow.Active ==1)
                        {#>
                         style="background-color:#C6DFF9"
                        <#}
                        else if(objRow.isEnroll ==1)
                        {#>
                        style="background-color:#B0C4DE"
                        <#}
                       
                      
                         else if(objRow.IsSalesApproved ==1)
                        {#>
                        style="background-color:#CC99FF"
                        <#}
                       else if(objRow.IsFinancialApproved ==1)
                        {#>
                        style="background-color:#3399FF"
                        <#}

                         else if(objRow.IsApproved ==1)
                        {#>
                         style="background-color:#FFC0CB"
                        <#}
                        else if(objRow.empVerified ==1)
                        {#>
                          style="background-color:#90EE90"
                        <#}
                        else if(objRow.Active ==0)
                        {#>
                        style="background-color:#FFFFFF"
                        <#}
                        #>
                        
                         >
                    <td class="GridViewLabItemStyle"><#=j+1#></td>
                        <td class="GridViewLabItemStyle"><#=objRow.TypeName#></td>
                    <td class="GridViewLabItemStyle" id="tdCompany_Name" style="width:200px;"><#=objRow.Company_Name#></td>
                    <td class="GridViewLabItemStyle" id="tdadd1" style="width:260px;"><#=objRow.add1#></td>
                    <td class="GridViewLabItemStyle" id="tdMinBusinessCommitment" style="width:90px;text-align:right"><#=objRow.MinBusinessCommitment#></td>                      
                    <td class="GridViewLabItemStyle" id="tdInvoiceBillingCycle" style="width:80px;"><#=objRow.InvoiceBillingCycle#></td>
                    <td class="GridViewLabItemStyle" id="tdcreatorUsername" style="width:180px;"><#=objRow.CreatedBy#></td>
                    <td class="GridViewLabItemStyle" id="tdCreatorDate" style="width:90px;text-align:center"><#=objRow.CreatedDate#></td>
                               
                    <td class="GridViewLabItemStyle" id="td4" style="width:60px;text-align:center">
                       <input type="button" id="btnApproved" class="ItDoseButton"   onclick="enroll(this)" 
                                <#if(objRow.CanApprove=="1"){#>
                            style="display:none"
                            <#}#>
                        <#if(objRow.IsDirectApprove=="1"){#>
                            value="Approved"
                            <#}  else
                        {#> 
                        value="Verified" <#}
                        #>
                        
                                 />
                        </td>    
                        <td class="GridViewLabItemStyle" id="tdEnrollID" style="width:120px;display:none"><#=objRow.EnrollID#></td>  
                        <td class="GridViewLabItemStyle" id="tdApprovalPendingByID" style="width:120px;display:none"><#=objRow.ApprovalPendingByID#></td>                                    
                        <td class="GridViewLabItemStyle" id="td1" style="text-align:center">
                            <img src="../../App_Images/view.GIF" style="cursor:pointer" onclick="viewEnrolment(this)" />
                            </td>       
                        <td class="GridViewLabItemStyle" id="td2" style="text-align:center">
                            <#if(objRow.TypeName=="HLM"){#>
                            <img src="../../App_Images/view.GIF" style="cursor:pointer" onclick="viewHLMReport(this)" />
                            <#}#>
                            </td>                             
                    </tr>
        <#}
        #>       
     </table>
    </script>
    <script type="text/javascript">
        function onSucessEnroll(result, Status) {
            var result1 = jQuery.parseJSON(result);
            if (Status == "IsEnroll") {
                if (result1[0] == "1")
                    alert('Enrolment Already Approved');
                else
                    location.href = 'EnrolmentMaster.aspx?EnrolID=' + result1[0] + '&ApprovalID=' + result1[1] + '';
            }
            else
                location.href = 'EnrolmentMaster.aspx?EnrolID=' + result1[0] + '&ApprovalID=' + result1[1] + '&View=' + $("#lblView").text() + '';
        }
        function onFailureEnroll(result) {

        }
        function enroll(rowid) {
            jQuery(rowid).closest('tr').find("#btnApproved").val('Submitting...').attr('disabled', 'disabled');
            PageMethods.encryptEnroll(jQuery(rowid).closest('tr').find("#tdEnrollID").text(), jQuery(rowid).closest('tr').find("#tdApprovalPendingByID").text(),"IsEnroll", onSucessEnroll, onFailureEnroll,"IsEnroll");
        }
        function viewEnrolment(rowid) {
            PageMethods.encryptEnroll(jQuery(rowid).closest('tr').find("#tdEnrollID").text(), jQuery(rowid).closest('tr').find("#tdApprovalPendingByID").text(), "IsView", onSucessEnroll, onFailureEnroll, "IsView");         
        }
        function viewHLMReport(rowid) {
            PageMethods.HLMReport(jQuery(rowid).closest('tr').find("#tdEnrollID").text(), onSucessHLM, onFailureEnroll);

        }
        function onSucessHLM(result) {
            if (result == 1)
                window.open('../common/ExportToExcel.aspx');
            else
                showerrormsg("No Record Found");
        }
    </script>
</asp:Content>

