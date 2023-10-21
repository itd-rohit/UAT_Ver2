<%@ Page  Language="C#" MasterPageFile="~/Design/DefaultHome.master" ClientIDMode="Static" AutoEventWireup="true" CodeFile="EnrolmentSearch.aspx.cs" Inherits="Design_Sales_EnrolmentSearch" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%: System.Web.Optimization.Scripts.Render("~/bundles/MsAjaxJs") %>
     <div id="Pbody_box_inventory" style=" text-align: left;width:1304px">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;width:1300px">
            <b>Enrolment Search<br />
            </b>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory" style="text-align: left;width:1300px">
        
               
           
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
    <input type="button" value="Search" class="searchbutton" onclick="bindEnrolment()" id="btnSearch" />
</td>
                    </tr>
                </table>          
        <div id="div_Enrolment"  style="max-height:450px; overflow-y:auto; overflow-x:hidden;">                            
             </div>           
            </div>
         </div>
    <script type="text/javascript">
        function onSucessEnrollSearch(result) {
            EnrolData = jQuery.parseJSON(result);
            if (EnrolData != null) {
                var output = jQuery('#sc_Enrolment').parseTemplate(EnrolData);
                jQuery('#div_Enrolment').html(output);
            }
            else {
                jQuery('#lblMsg').text('No Result Found');
                jQuery('#div_Enrolment').html('');
            }
            jQuery("#btnSearch").removeAttr('disabled').val("Search");
        }
        function bindEnrolment() {
            jQuery('#lblMsg').text('');
            jQuery('#btnSearch').attr('disabled', 'disabled').val('Searching...');
            PageMethods.bindEnrolment(jQuery('#<%=txtFromDate.ClientID%>').val(), jQuery('#<%=txtToDate.ClientID%>').val(), onSucessEnrollSearch, onFailureEnroll);            
        }
        function onSucessEnroll(result, TypeName) {
            if (result == "1") {
                jQuery('#lblMsg').text('Already Registered');
                return;
            }
            if (TypeName == "PUP")
                window.open('../Master/PUPMaster.aspx?EnrolID=' + result);
            else
                window.open('../Master/Centremaster.aspx?EnrolID=' + result);
        }
        function onFailureEnroll() {
            alert("Error ");
        }
        function ShowDetail(rowID) {
            var TypeName = jQuery(rowID).closest('tr').find('#tdTypeName').text();
            PageMethods.checkEnrolment(jQuery(rowID).closest('tr').find('#tdID').text(), onSucessEnroll, onFailureEnroll, TypeName);
        }
    </script>
     <script id="sc_Enrolment" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_PUPEnrolment"   style="border-collapse:collapse; width:100%;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:30px;">S.No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="display:none;">ID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px">Type</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:200px">Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px">Created Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:200px">Created By</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:100px">Contact No.</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:200px">Sales Person </th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:40px">Registered</th>		       
</tr>
<#  
            var dataLength=EnrolData.length;            
            var objRow;   
        for(var j=0;j<dataLength;j++)
        {
        objRow = EnrolData[j];        
            #>
<tr id="<#=j+1#>" style="background-color:white;">
    <td class="GridViewLabItemStyle"><#=j+1#></td>  
    <td id="tdID" class="GridViewLabItemStyle" style="display:none"><#=objRow.ID#></td>
    <td id="tdTypeName" class="GridViewLabItemStyle" style=""><#=objRow.TypeName#></td>
    <td class="GridViewLabItemStyle" style=""><#=objRow.Company_Name#></td>
    <td class="GridViewLabItemStyle" style=""><#=objRow.CreatedDate#></td>
    <td class="GridViewLabItemStyle" style=""><#=objRow.CreatedBy#></td> 
    <td class="GridViewLabItemStyle" style=""><#=objRow.Mobile#></td> 
    <td class="GridViewLabItemStyle" style=""><#=objRow.Name#></td>        
    <td class="GridViewLabItemStyle" style="">
    <#
    if(objRow.ISEnroll=="0"){#>
    <img id="img1" src="../../App_Images/Post.gif"   onclick="ShowDetail(this)" style="cursor:pointer;"/>
    <#}
    #>
    </td>
</tr> 
<#}#> 
        </table>         
          </script>  
</asp:Content>

