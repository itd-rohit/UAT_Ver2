<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static"  AutoEventWireup="true" CodeFile="SalesVerification.aspx.cs" Inherits="Design_Sales_SalesVerification" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
      <%: Scripts.Render("~/bundles/MsAjaxJs") %>
      
     <div id="Pbody_box_inventory" style="width:1304px;">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server"  EnablePageMethods="true"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;width:1300px;">
            <b>Sales Admin Verification Search</b><br />
            <asp:Label ID="lblMsg" runat="server" Font-Bold="True" ForeColor="Red" ClientIDMode="Static"></asp:Label>
            <asp:Label ID="lblIsSales" runat="server" style="display:none" ClientIDMode="Static"></asp:Label>
            
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
                    <tr>
<td style="text-align: center; font-weight: 700;" colspan="4">
    <input type="button" value="Search" class="searchbutton" onclick="searchVerification()" id="btnSearch" />
</td>
                    </tr>
                </table>
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
        function onSucessSalesSearch(result) {
            SalesData = jQuery.parseJSON(result);
            if (SalesData != null) {
                var output = jQuery('#sc_SalesVerified').parseTemplate(SalesData);
                jQuery('#divEnrolment').html(output);
                jQuery('#<%=lbltotal.ClientID%>').text(SalesData.length);
            }
            else {
                jQuery('#lblMsg').text('No Result Found');
                jQuery('#divEnrolment').html('');
                jQuery('#<%=lbltotal.ClientID%>').text('0');
            }
            jQuery("#btnSearch").removeAttr('disabled').val("Search");
        }
        function searchVerification() {
            jQuery('#btnSearch').attr('disabled', 'disabled').val('Searching...');
            jQuery('#lblMsg').text('');
            PageMethods.bindSalesEnrolment(jQuery('#<%=txtFromDate.ClientID%>').val(), jQuery('#<%=txtToDate.ClientID%>').val(), onSucessSalesSearch, onFailureEnroll);            
        }
        function onSucessEnroll(result) {
            if (result == "1") {
                jQuery('#lblMsg').text('Already Registered');
            }
            else {
                location.href = 'EnrolmentVerification.aspx?EnrolID=' + result + '&Verified=' + jQuery("#lblIsSales").text() + '';
            }
        }
        function onFailureEnroll(result) {

        }
        function ShowDetail(rowID) {
            PageMethods.checkSalesEnrolment(jQuery(rowID).closest('tr').find('#tdID').text(), onSucessEnroll, onFailureEnroll);
        }
             </script>
     <script id="sc_SalesVerified" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_SalesVerified"   style="border-collapse:collapse; width:100%;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:30px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="display:none;">ID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px">Type</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:200px">Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px">Created Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:200px">Created By</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:100px">Contact No.</th> 
         
            <th class="GridViewHeaderStyle" scope="col" style="width:80px">Sales Admin Approved </th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:80px">Financial Admin Approved </th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:40px">Approve</th> 
	
	       

</tr>
<#  var dataLength=SalesData.length;
             
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {

        objRow = SalesData[j];
         
            #>
<tr id="<#=j+1#>" style="background-color:white;">
<td class="GridViewLabItemStyle"><#=j+1#></td>  
<td id="tdID" class="GridViewLabItemStyle" style="display:none"><#=objRow.ID#></td>
<td id="tdTypeName" class="GridViewLabItemStyle" style=""><#=objRow.TypeName#></td>
<td class="GridViewLabItemStyle" style=""><#=objRow.Company_Name#></td>
<td class="GridViewLabItemStyle" style=""><#=objRow.CreatedDate#></td>
<td class="GridViewLabItemStyle" style=""><#=objRow.CreatedBy#></td> 
    <td class="GridViewLabItemStyle" style=""><#=objRow.Mobile#></td> 
   
    <td class="GridViewLabItemStyle" style=""><#=objRow.SalesApproved#></td> 
     <td class="GridViewLabItemStyle" style=""><#=objRow.FinancialApproved#></td> 
    
<td class="GridViewLabItemStyle" style="">
 <#
    if(objRow.ShowButton=="0")
    {#>
    <img id="img1" src="../../App_Images/Post.gif"   onclick="ShowDetail(this)" style="cursor:pointer;"/>
    <#}
     #>
</td>

</tr> 
<#}#> 
        </table>
          
          </script>  
</asp:Content>

