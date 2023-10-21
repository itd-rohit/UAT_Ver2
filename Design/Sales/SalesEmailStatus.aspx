<%@ Page  ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="SalesEmailStatus.aspx.cs" Inherits="Design_Sales_SalesEmailStatus" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <%: System.Web.Optimization.Scripts.Render("~/bundles/MsAjaxJs") %>
      <%: Scripts.Render("~/bundles/Chosen") %>
    <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
     <script src="../../Scripts/jquery-confirm.min.js" type="text/javascript"></script> 
      <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
          <script type="text/javascript" src="../../Scripts/jquery.table2excel.min.js"></script>
     <div id="Pbody_box_inventory" style=" text-align: left;width:1304px">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;width:1300px">
            <b>Sales Email Status<br />
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
                        <td style="text-align: right; font-weight: 700;width:10%">To Date :&nbsp;</td>
                        <td>
                             <asp:TextBox ID="txtToDate" runat="server" Width="110px" />
                        <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </td>
                    </tr>
                                 <tr>
<td style="text-align: right; font-weight: 700;width:30%">Type :&nbsp;</td>
                        <td style="width:20%">   
                             <asp:DropDownList ID="ddlEmailTypeID" runat="server" Width="210px"    class="ddlType chosen-select">
                            </asp:DropDownList>
                        </td>
                        <td style="text-align: right; font-weight: 700;width:10%">EmailTo :&nbsp; </td>
                        <td>
                            <asp:TextBox ID="txtEmailTo" runat="server" MaxLength="100" Width="280px"> </asp:TextBox>
                        </td>
                    </tr>
                                <tr>
                                    <td colspan="4">
                                        &nbsp;&nbsp;
                                    </td>
                                </tr>
                  
                    <tr>
<td style="text-align: center; font-weight: 700;" colspan="4">
    <input type="button" value="Search" class="searchbutton" onclick="bindSalesEmail('2')" id="btnSearch" />
    &nbsp;&nbsp;
  <a onclick="exportReport()" class="searchbutton" id="btnexportReport" style="display:none">Report
                  <img src="../../App_Images/xls.png" width="22" style="cursor:pointer;text-align:center" />
              </a>
     <table  style="width:100%;border-collapse:collapse">
                        <tr>
                            <td style="width:30%">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                            <td style="background-color:#3399FF;width:50px;border:1px solid black;cursor:pointer;" onclick="bindSalesEmail('1')"></td>
                                     <td style="text-align:left"><b>Send</b></td>

                                      <td style="background-color:#90EE90;width:50px;border:1px solid black;cursor:pointer;" onclick="bindSalesEmail('0')"></td>
                                     <td style="text-align:left"><b>NotSend</b></td>

                          
                             <td style="width:40%">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                        </tr>
                    </table>
</td>
                    </tr>
                </table>          
        <div id="div_SalesEmail"  style="max-height:450px; overflow-y:auto; overflow-x:hidden;">                            
             </div>           
            </div>
         </div>
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
                 $(selector).chosen(config[selector]);
             }

             jQuery('#ddlEmailTypeID').trigger('chosen:updated');
             
         });
         function onSucessSalesSearch(result) {
             SalesData = jQuery.parseJSON(result);
             if (SalesData != null) {
                 var output = jQuery('#sc_Sales').parseTemplate(SalesData);
                 jQuery('#div_SalesEmail').html(output);
                // jQuery('#btnexportReport').show();
jQuery("#tb_grdSales").tableHeadFixer({

             });
             }
             else {
                 jQuery('#lblMsg').text('No Result Found');
                 jQuery('#div_SalesEmail').html('');
                 jQuery('#btnexportReport').hide();
             }
             jQuery("#btnSearch").removeAttr('disabled').val("Search");
         }
         function bindSalesEmail(con) {
             jQuery('#lblMsg').text('');
             jQuery('#btnSearch').attr('disabled', 'disabled').val('Searching...');
             PageMethods.SalesEmail(jQuery('#txtFromDate').val(), jQuery('#txtToDate').val(),con,jQuery('#ddlEmailTypeID').val(),jQuery('#txtEmailTo').val(), onSucessSalesSearch, onFailureEmail);
        }
        
         function onFailureEmail(result) {
             jQuery("#btnSearch").removeAttr('disabled').val("Search");
            alert("Error ");
        }
       
    </script>
    <script id="sc_Sales" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdSales"   style="border-collapse:collapse; width:100%;">
 <thead>
		<tr id="Header">
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;">S.No.</th>
            <th class="GridViewHeaderStyle noExl" scope="col" style="display:none;">ID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px">Type</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:40px">Status</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px">Created Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:120px">Created By</th> 
            <th class="GridViewHeaderStyle noExl"  scope="col" style="width:60px;">Email To</th> 
            <th class="GridViewHeaderStyle noExl" scope="col" style="width:60px;">Email CC </th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none">Email To</th> 
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;display:none">Email CC </th> 
            <th class="GridViewHeaderStyle noExl" scope="col" style="width:200px">Email Content </th> 
            <th class="GridViewHeaderStyle noExl" scope="col" style="width:40px" >Resend</th>		       
</tr>
</thead> 


                                
<#  
            var dataLength=SalesData.length;            
            var objRow;   
        for(var j=0;j<dataLength;j++)
        {
        objRow = SalesData[j];        
            #>
<tr id="<#=j+1#>" 
     <#
 if(objRow.IsSend =="1")
                        {#>
                        style="background-color:#3399FF"
                        <#}                                             
                        else if(objRow.IsSend =="0")
                        {#>
                        style="background-color:#90EE90"
                        <#}
                        #>
    >
    <td class="GridViewLabItemStyle"><#=j+1#></td>  
    <td id="tdID" class="GridViewLabItemStyle noExl" style="display:none"><#=objRow.ID#></td>
    <td class="GridViewLabItemStyle" style=""><#=objRow.EmailTypeName#></td>
    <td class="GridViewLabItemStyle" style=""><#=objRow.EmailStatus#></td>
    <td class="GridViewLabItemStyle" style=""><#=objRow.CreatedDate#></td>
    <td class="GridViewLabItemStyle" style=""><#=objRow.CreatedBy#></td> 
    <td class="GridViewLabItemStyle noExl" style="text-align:center" ><img id="imgMailTo" src="../../App_Images/Post.gif"   onclick="mailTo(this,'EmailTo')" style="cursor:pointer;"/></td> 
    <td class="GridViewLabItemStyle noExl" style="text-align:center">
         <#
    if(objRow.EmailCC!=""){#>
        <img id="img2" src="../../App_Images/Post.gif"   onclick="mailTo(this,'EmailCC')" style="cursor:pointer;"/>
        <#}
    #>
    </td> 
    <td class="GridViewLabItemStyle" id="tdEmailTo" style=" display:none"><#=objRow.EmailTo#></td>   
    <td class="GridViewLabItemStyle" id="tdEmailCC" style=" display:none"><#=objRow.EmailCC#></td>   
    <td class="GridViewLabItemStyle noExl" style=""><#=objRow.EmailContent#></td>  
       
    <td class="GridViewLabItemStyle noExl" style="">
    
    <img id="img1" src="../../App_Images/Email-resend.png"   onclick="mailResend(this)" style="cursor:pointer;"/>
    
    </td>
</tr> 
<#}#> 
        </table>         
          </script>  
    <script type="text/javascript">
        function mailResend(rowID) {
            jQuery('#lblMsg').text('');
            var ID = jQuery(rowID).closest('tr').find("#tdID").text();
         
            confirmationBox('Are You Sure to Resend Mail ?',ID);

            
        }
        function onSucessMailSend(result) {

            if (result != "-1")
                jQuery('#lblMsg').text('Resend Successfully');
            else
                jQuery('#lblMsg').text('Not Send');
        }
        function mailTo(rowID, status) {
            var emailID = "";
            if(status=='EmailTo')
                emailID = jQuery(rowID).closest('tr').find("#tdEmailTo").text();
            else if (status == 'EmailCC')
                emailID = jQuery(rowID).closest('tr').find("#tdEmailCC").text();
            var appendText = [];
            appendText.push('<table id="tbSelected" rules="all" border="1" style="border-collapse: collapse; width: 100%; table-layout: fixed;" class="GridViewStyle">');
            appendText.push("<tr >");
            
            appendText.push('<th class="GridViewHeaderStyle" scope="col" style="width: 40px; text-align: center">' + status + '</th></tr >');

            appendText.push("<tr >");
            appendText.push('<td class="GridViewLabItemStyle" style="text-align:center;word-wrap: break-word;overflow-wrap: break-word;" >' + emailID + ' </td> </tr >');

            
            appendText.push('</table>');
            appendText = appendText.join(" ");
            confirmationBoxEmail(appendText);

        }
    </script>
    <script type="text/javascript">
        function exportReport() {

            $("#tb_grdSales").remove(".noExl").table2excel({
                name: "Sales Email Status",
                filename: "SalesEmailStatus", //do not include extension
                exclude_inputs: true
            });
        }
        function confirmationBoxEmail(contentMsg) {
            $.dialog({
                useBootstrap: false,
                animation: 'zoom',
                closeAnimation: 'scale',
                opacity: 0.5,
                theme: 'light',
                type: 'red',
                typeAnimated: true,
                boxWidth: '620px',
                title: '',
                content: contentMsg,
                offsetTop: 40,
                offsetBottom: 40,
            });
        }
    </script>
   <script type="text/javascript">
       function confirmationBox(contentMsg, ID) {
           jQuery.confirm({
               title: 'Confirmation!',
               content: contentMsg,
               animation: 'zoom',
               closeAnimation: 'scale',
               useBootstrap: false,
               opacity: 0.5,
               theme: 'light',
               type: 'red',
               typeAnimated: true,
               boxWidth: '480px',
               buttons: {
                   'confirm': {
                       text: 'Yes',
                       useBootstrap: false,
                       btnClass: 'btn-blue',
                       action: function () {
                           confirmationAction(ID);
                       }
                   },
                   somethingElse: {
                       text: 'No',
                       action: function () {
                           clearAction();
                       }
                   },
               }
           });
       }
       function confirmationAction(ID) {
           PageMethods.resendMail(ID, onSucessMailSend, onFailureEmail);
       }
       function clearAction() {

       }
   </script>
   
</asp:Content>

