<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ViewTicket.aspx.cs" Inherits="Design_CallCenter_ViewTicket" Title="View Support Ticket" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
     <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
      <script type="text/javascript" src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <%--<%: Scripts.Render("~/bundles/JQueryUIJs") %>--%>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <script src="../../Scripts/datatables.min.js"></script>

    <style>
        #NewRecord table th {
            border-top: 1px solid #000;
            BACKGROUND-COLOR: #9dff8c;
            font-size: 12px;
            font-weight: normal;
        }

        #OldRecord table th {
            border-top: 1px solid #000;
            BACKGROUND-COLOR: #ffcc8c;
            font-size: 12px;
            font-weight: normal;
        }

        #ResolvedRecord table th {
            border-top: 1px solid #000;
            BACKGROUND-COLOR: #9fb7c5;
            font-size: 12px;
            font-weight: normal;
        }

        #NewRecord table td, #OldRecord table td, #ResolvedRecord table td {
            font-size: 11px;
        }

        td.details-control {
            background: url('../../App_Images/details_open.png') no-repeat left center;
            cursor: pointer;
        }

        tr.shown td.details-control {
            background: url('../../App_Images/details_close.png') no-repeat left center;
        }

        .ReplyTable .GridViewLabItemStyle {
            background-color: #ccc;
        }

        #tbl_Notify .GridViewHeaderStyle, #tbl_Notify .GridViewLabItemStyle {
            padding: 5px;
        }

        .ui-dialog {
            margin-left: 22%!important;
        }

        .details-control {
            width: 28px !important;
            padding: 0!important;
            border-right: none!important;
        }
    </style>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server"></Ajax:ScriptManager>
   
    <div id="Pbody_box_inventory" style="width: 1340px; margin: 2px;">         
        <div class="POuter_Box_Inventory" style="width: 1335px; text-align: center;">
            <b>View Issues</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" Font-Size="12pt" Font-Bold="true" ForeColor="Red"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory" style="width: 1335px; min-height: 550px;">
            <div class="Purchaseheader">
                Search Result
            </div>
            <table class="tblFileDes">
                <tr>
                    <td style="text-align: right">Date :&nbsp;</td>
                    <td colspan="3">
                        <asp:TextBox ID="txtFormDate" runat="server" Width="90px"></asp:TextBox>
                        <cc1:CalendarExtender ID="ce_dtfrom" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtFormDate" />
                        <asp:TextBox ID="txtFromTime" runat="server" Width="66px"></asp:TextBox>
                        <cc1:MaskedEditExtender runat="server" ID="mee_txtFromTime" Mask="99:99:99" TargetControlID="txtFromTime"
                            AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                        </cc1:MaskedEditExtender>
                        <cc1:MaskedEditValidator runat="server" ID="mev_txtFromTime"
                            ControlExtender="mee_txtFromTime"
                            ControlToValidate="txtFromTime"
                            InvalidValueMessage="*">
                        </cc1:MaskedEditValidator>
                        <span style="margin-left: 6px;">- </span>
                        <asp:TextBox ID="txtToDate" runat="server" Width="90px"></asp:TextBox>
                        <cc1:CalendarExtender ID="ce_dtTo" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtToDate" />
                        <asp:TextBox ID="txtToTime" runat="server" Width="66px"></asp:TextBox>
                        <cc1:MaskedEditExtender runat="server" ID="mee_txtToTime" Mask="99:99:99" TargetControlID="txtToTime"
                            AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                        </cc1:MaskedEditExtender>
                        <cc1:MaskedEditValidator runat="server" ID="mev_txtToTime"
                            ControlExtender="mee_txtToTime" ControlToValidate="txtToTime"
                            InvalidValueMessage="*">
                        </cc1:MaskedEditValidator>
                    </td>
                    <td style="text-align: right">&nbsp;&nbsp;&nbsp;Ticket&nbsp;No.&nbsp;:&nbsp;</td>
                    <td>
                        <asp:TextBox ID="txtIssueNo" runat="server" Width="130px"></asp:TextBox></td>

                    <td style="text-align: right">&nbsp;&nbsp;&nbsp;Status&nbsp;:&nbsp;</td>
                    <td>
                        <select id="ddlStatus" style="width: 150px">
                        </select></td>
                    <td style="text-align: right">&nbsp;&nbsp;&nbsp;Group&nbsp;:&nbsp;</td>
                    <td>
                        <select id="ddlgroup" style="width: 150px">
                        </select></td>
                </tr>
                <tr>
                    <td style="text-align: right; display: none">&nbsp;&nbsp;From&nbsp;Vial&nbsp;ID&nbsp;:&nbsp;</td>
                    <td style="display: none">
                        <asp:TextBox ID="txtFromBarcode" runat="server" Width="130px"></asp:TextBox>
                    </td>

                    <td style="text-align: right; display: none">&nbsp;&nbsp;To&nbsp;Vial&nbsp;ID&nbsp;:&nbsp;</td>
                    <td style="display: none">
                        <asp:TextBox ID="txtToBarcode" Style="width: 130px;" runat="server"></asp:TextBox>
                    </td>


                    <td style="text-align: right">&nbsp;&nbsp;&nbsp;UHID&nbsp;No.&nbsp;:&nbsp;</td>
                    <td>
                        <asp:TextBox ID="txtRegNo" Style="width: 130px;" runat="server"></asp:TextBox></td>
                    <td style="text-align: right">&nbsp;&nbsp;&nbsp;SIN&nbsp;No.&nbsp;:&nbsp;</td>
                    <td>
                        <asp:TextBox ID="txtVialId" runat="server" Width="130px"></asp:TextBox>
                    </td>

                    <td style="text-align: right">&nbsp;&nbsp;&nbsp;Client Code :&nbsp;</td>
                    <td>
                        <asp:TextBox ID="txtPcc" runat="server" Style="width: 130px;"></asp:TextBox></td>

                    <td style="text-align: right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="10">&nbsp;
                    </td>
                </tr>
                <tr style="text-align: center">

                    <td colspan="10">
                        <input type="button" class="searchbutton" id="searchid" value="Search" onclick="Search();" />
                        
                        <asp:Button ID="btnExTOExcel1" Visible="false" CssClass="searchbutton" Text="Detail Report" runat="server" OnClick="btn_clickExportToExcel"></asp:Button>

                    </td>
                </tr>
            </table>


            <div style="border-bottom: 1px solid #ccc; padding-bottom: 7px; margin-bottom: 7px;">
                <div style="width: 27%; float: LEFT; FONT-SIZE: 16PX; font-weight: bold; color: #000000;">New Ticket</div>
                <table style="width: 20%; margin: 0 auto; margin-top: 10px;">
                    <tr>
                        <td style="border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; cursor: pointer; width: 25px; border-bottom: black thin solid; background-color: #768aa3;"
                            onclick="getdataList('1','New');">&nbsp; &nbsp;&nbsp;</td>
                        <td style="text-align: left; font-size: 11pt;">Read</td>
                        <td style="border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; cursor: pointer; width: 25px; border-bottom: black thin solid; background-color: #ffffff;"
                            onclick="getdataList('0','New');">&nbsp; &nbsp;&nbsp;</td>
                        <td style="text-align: left; font-size: 11pt;">UnRead</td>

                    </tr>

                </table>
            </div>
            <div id="NewRecord" style="display: none;">
                <table id="datatable" class="table stripe cell-border">
                    <thead>
                        <tr>
                            
                             <th style="height: 30px; width: 50px; text-align: center">ID</th>
                            <th style="height: 30px; width: 150px; text-align: center">Ticket No.</th>
                            <th style="width: 62px; text-align: center">Status</th>
                            <th style="width: 120px; text-align: center">Group</th>
                            <th style="width: 120px; text-align: center">Category</th>
                            <th style="width: 120px; text-align: center">SubCategory</th>
                            <th style="width: 150px; text-align: center">Subject</th>

                            <th style="width: 150px; text-align: center">Query</th>


                            <th style="width: 150px; text-align: center">SIN No.</th>

                            <th style="width: 150px; text-align: center">UHID No.</th>

                            <th style="width: 100px; text-align: center">Raised Location</th>

                            <th style="width: 220px; text-align: center">Test Name</th>

                            <th style="width: 80px; text-align: center">Raised By</th>

                            <th style="width: 80px; text-align: center">Raised Date</th>
                            <th style="width: 80px; text-align: center">Elapsed Time</th>
                        </tr>
                    </thead>
                </table>
            </div>
            <div id="NewRecordnotfound" style="border-bottom: 1px solid #ccc; margin-top: 10px; display: none; margin-top: 10px; height: 180px; text-align: center; font-size: 18px; vertical-align: middle; padding-top: 16px; font-weight: bold">
                <p>Record Not Found</p>
            </div>
            <div style="border-bottom: 1px solid #ccc; padding-bottom: 7px; margin-bottom: 7px;">
                <div style="width: 27%; float: LEFT; FONT-SIZE: 16PX; font-weight: bold; color: #000000;">Old Ticket</div>
                <table style="width: 70%; margin: 0 auto; margin-top: 10px;">
                    <tr>
                        <td style="border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; cursor: pointer; width: 25px; border-bottom: black thin solid; background-color: #b3b9c0;"
                            onclick="getdataList('Initial Reply','Old');">&nbsp; &nbsp;&nbsp;</td>
                        <td style="text-align: left; font-size: 11pt">Initial Reply</td>
                        <td style="border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; cursor: pointer; width: 25px; border-bottom: black thin solid; background-color: #6993ca;"
                            onclick="getdataList('Reply','Old');">&nbsp; &nbsp;&nbsp;</td>
                        <td style="text-align: left; font-size: 11pt;">Reply</td>
                        <td style="border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; cursor: pointer; width: 25px; border-bottom: black thin solid; background-color: #00cccc"
                            onclick="getdataList('Assign','Old');">&nbsp; &nbsp;&nbsp;</td>
                        <td style="text-align: left; font-size: 11pt">Assign</td>
                        <td style="border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; cursor: pointer; width: 25px; border-bottom: black thin solid; background-color: #ccffcc;"
                            onclick="getdataList('ReOpen','Old');">&nbsp; &nbsp;&nbsp;</td>
                        <td style="text-align: left; font-size: 11pt;">ReOpen</td>
                        <td style="border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; cursor: pointer; width: 25px; border-bottom: black thin solid; background-color: #ffd2d2;"
                            onclick="getdataList('Acknowledge','Old');">&nbsp; &nbsp;&nbsp;</td>
                        <td style="text-align: left; font-size: 11pt;">Acknowledge</td>
                        <td style="border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; cursor: pointer; width: 25px; border-bottom: black thin solid; background-color: #ffffff;"
                            onclick="getdataList('0','Old');">&nbsp; &nbsp;&nbsp;</td>
                        <td style="text-align: left; font-size: 11pt;">UnRead</td>

                    </tr>
                </table>
            </div>
            <div style="margin-top: 10px; display: none;" id="OldRecord">
                <table id="datatable1" class="table stripe cell-border">
                    <thead>
                        <tr>
                                  <th style="height: 30px; width: 20px; text-align: center"></th>
                           <th style="height: 30px; width: 150px; text-align: center">Ticket No.</th>
                           
                            <th style="width: 62px; text-align: center">Status</th>
                            <th style="width: 120px; text-align: center">Group</th>
                            <th style="width: 120px; text-align: center">Category</th>

                            <th style="width: 120px; text-align: center">SubCategory</th>

                            <th style="width: 150px; text-align: center">Subject</th>

                            <th style="width: 250px; text-align: center">Query</th>


                            <th style="width: 150px; text-align: center">SIN No.</th>

                            <th style="width: 150px; text-align: center">UHID No.</th>

                            <th style="width: 100px; text-align: center">Raised Location</th>

                            <th style="width: 220px; text-align: center">Test Name</th>

                            <th style="width: 80px; text-align: center">Raised By</th>

                            <th style="width: 80px; text-align: center">Raised Date</th>
                            <th style="width: 80px; text-align: center">Elapsed Time</th>
                            <th style="width: 80px; text-align: center">Elapsed Second</th>

                        </tr>
                    </thead>
                </table>
            </div>
            <div id="OldRecordnotfound" style="border-bottom: 1px solid #ccc; margin-top: 10px; display: none; margin-top: 10px; height: 180px; text-align: center; font-size: 18px; vertical-align: middle; padding-top: 16px; font-weight: bold">
                <p>Record Not Found</p>
            </div>
            <div style="border-bottom: 1px solid #ccc; padding-bottom: 7px; margin-bottom: 7px;">
                <div style="width: 27%; float: LEFT; FONT-SIZE: 16PX; font-weight: bold; color: #000000;">Resolved Ticket</div>
                <table style="width: 20%; margin: 0 auto; margin-top: 10px;">
                    <tr>
                        <td style="border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; cursor: pointer; width: 25px; border-bottom: black thin solid; background-color: #768aa3;"
                            onclick="getdataList('1','Close');">&nbsp; &nbsp;&nbsp;</td>
                        <td style="text-align: left; font-size: 11pt;">Read</td>
                        <td style="border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; cursor: pointer; width: 25px; border-bottom: black thin solid; background-color: #ffffff;"
                            onclick="getdataList('0','Close');">&nbsp; &nbsp;&nbsp;</td>
                        <td style="text-align: left; font-size: 11pt;">UnRead</td>

                    </tr>
                </table>
            </div>
            <div style="margin-top: 10px; display: none;" id="ResolvedRecord">
                <table id="datatable2" class="table stripe cell-border">
                    <thead>
                        <tr>
                              <th style="height: 30px; width: 20px; text-align: center"></th>
                            <th style="height: 30px; width: 150px; text-align: center">Ticket No.</th>
                            
                            <th style="width: 62px; text-align: center">Status</th>
                             <th style="width: 120px; text-align: center">Group</th>
                            <th style="width: 120px; text-align: center">Category</th>

                            <th style="width: 120px; text-align: center">SubCategory</th>

                            <th style="width: 150px; text-align: center">Subject</th>

                            <th style="width: 250px; text-align: center">Query</th>


                            <th style="width: 150px; text-align: center">SIN No.</th>

                            <th style="width: 150px; text-align: center">UHID No.</th>

                            <th style="width: 100px; text-align: center">Raised Location</th>

                            <th style="width: 220px; text-align: center">Test Name</th>

                            <th style="width: 80px; text-align: center">Raised By</th>

                            <th style="width: 80px; text-align: center">Raised Date</th>
                             <th style="width: 80px; text-align: center">ResolvedBy</th>                            
                            <th style="width: 80px; text-align: center">TAT Time</th>
                            <th style="width: 80px; text-align: center">TAT Time</th>

                        </tr>
                    </thead>
                </table>
            </div>
            <div id="Resolvednotfound" style="border-bottom: 1px solid #ccc; margin-top: 10px; display: none; margin-top: 10px; height: 180px; text-align: center; font-size: 18px; vertical-align: middle; padding-top: 16px; font-weight: bold">
                <p>Record Not Found</p>
            </div>
        </div>
    </div>

     <div id="divReplyOutput" style="display:none;" >
                
            </div>
        <script id="tb_Reply" type="text/html"> 
            <div class="slider">
        <table class="GridViewStyle ReplyTable" cellspacing="0" rules="all"  id="tbl_Reply" width="100%" >
		<tr>
			<th class="GridViewHeaderStyle" style="width:40px;" >S.No.</th>
            <th class="GridViewHeaderStyle" style="width:110px; text-align:center;" >Replied By</th>
            <th class="GridViewHeaderStyle" style="width:120px;">Reply DateTime</th>            
            <th class="GridViewHeaderStyle" style="width:70px;">Attachment</th>          
			<th class="GridViewHeaderStyle" style="width:480px!important">Description</th>
             <th class="GridViewHeaderStyle" style="width:180px;">TAT Time</th>
             
         </tr>

       <#
              var dataLength=ReplyData.length;
            
              var objRow;  
            
        for(var j=0;j<dataLength;j++)
        { 
            var array=0;
        objRow = ReplyData[j];
         if(objRow.Files!='' && objRow.Files!=null){
           array = objRow.Files.split(",");
            }    
            #>
<tr>
    <td class="GridViewLabItemStyle"><#=j+1#></td>
<td class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.EmpName#></td>
    <td class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.dtEntry#></td>    
    <td class="GridViewLabItemStyle" style="text-align:center;">
<# 
         for(var i=0; i < array.length; i++){#> 
        <div style="margin-bottom: 10px;"><a class="im" url=" <#=array[i].split("#")[1]#>" style="cursor: pointer" href="../Lab/DownloadAttachment.aspx?FileName= <#=array[i].split("#")[0]#>&Type=3&FilePath=<#=array[i].split("#")[1]#>" target="_blank">
                                <img src="../../App_Images/attachment.png" />
                 <#=array[i].split("#")[0]#>
                              </a></div>
        <#}
 #>
    </td>
    <td class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.Answer#></td>
  <td class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.TATTime#></td>
</tr> 
  <#}#>

</table> 
            </div>  
           
    </script>

       <div id="dialog" title="Re-Notify">       
 <div style="width:100%;height:65px;" >

     <input type="hidden" value="0" id="SubcategoryID" />
         <input type="hidden" value="0" id="CenterID" />
     <input type="hidden" value="0" id="TicketNo" />
      <input type="hidden" value="" id="Group" />
         <input type="hidden" value="" id="Category" />
     <input type="hidden" value="" id="SubCategory" />
      <input type="hidden" value="" id="SinNo" />
         <input type="hidden" value="" id="UHIDNo" />
     <input type="hidden" value="" id="TestName" />
      <input type="hidden" value="" id="Subject" />
         <input type="hidden" value="" id="Message" />      

    

    <fieldset style="float:left; width:40%;">
    <legend>Re-Notify</legend>
    <label for="radioNotifyEmail">Re-Notify Email</label>
    <input type="radio" class="ChkRto radio" name="radioNotify" id="radioNotifyEmail" checked>
    <label for="smsNotify">Re-Notify SMS</label>
    <input type="radio" class="ChkRto radio" name="radioNotify" id="smsNotify"> 
   </fieldset>
  <fieldset  style="float:left; width:50%;">
    <legend>Employee Level </legend>
    <label for="Level1">Level 1</label>
    <input type="checkbox" class="ChkRto checkbox" name="Level1" id="Level1">
    <label for="Level2">Level 2</label>
    <input type="checkbox" class="ChkRto checkbox" name="Level2" id="Level2">
    <label for="Level3">Level 3</label>
    <input type="checkbox" class="ChkRto checkbox" name="Level3" id="Level3">
    
  </fieldset>
     </div>
           <div id="divSMS" style="margin-top:10px; margin-bottom:10px; display:none;"> 
              <p style=" " id="smstemplate"> Please look into the Ticket No <span id="smstempTicket">1</span> on urgent basis.</p>
               <div style="text-align:left;" id="smslevel">Comments:</div>
               <div>
             <textarea id="msg" rows="5" cols="101"></textarea>
                    Number of Characters Left:
                        <label id="lblremaingCharacters" style="background-color: #E2EEF1; color: Red; font-weight: bold;">
                        </label>

                   </div>
           </div>
               <div id="divmailSMS" style="margin-top:10px; margin-bottom:10px;">         
               <div style="text-align:left;">Message :</div>
               <div>
             <textarea id="msgmail" rows="5" cols="101"></textarea>                    
                   </div>
           </div>
      <div class="employeeList" style="height: 170px;max-height: 170px; min-height: 170px;overflow: hidden;overflow-y: auto;width: 100%;">
            <div id="divNotifyOutput">                
            </div>
         
        <script id="tb_Notify" type="text/html">            
        <table class="GridViewStyle" cellspacing="0" rules="all"  id="tbl_Notify" width="100%" >
            <thead>
		<tr>
			<th class="GridViewHeaderStyle" style="width:30px; text-align:left;" >S.No.</th>
            <th class="GridViewHeaderStyle" style="width:200px; text-align:left;" >Employee Name</th>
            <th class="GridViewHeaderStyle" style="width:150px;text-align:left;" id="EmailMobile">E-mailID</th>            
            <th class="GridViewHeaderStyle" style="width:40px;text-align:left;">Level</th> 
         </tr>
                </thead>
<tbody>
       <#
              var dataLength=EmployeeData.length;
            
              var objRow;  
            
        for(var j=0;j<dataLength;j++)
        { 
            
        objRow = EmployeeData[j];
         #>  
<tr>
    <td class="GridViewLabItemStyle" style="width:30px; text-align:left;" ><#=j+1#>&nbsp;<input type="checkbox" class="empcheckbox" name="empcheckbox" checked /> </td>
<td class="GridViewLabItemStyle" style="text-align:left;">  <#=objRow.EmpName#></td>
    <td class="GridViewLabItemStyle" style="text-align:left;">        
         <#if(objRow.Type=='SMS')  {#>
      <input style="width: 98%;" type="text" class="Email" <#if(objRow.mobile!=''){#>readonly="readonly"<#}#> value="<#=objRow.mobile#>" />
        <#}#>
        <#if(objRow.Type=='Email')  {#>
     <input style="width: 98%;" type="text" class="Email" <#if(objRow.Email!=''){#>readonly="readonly"<#}#> value="<#=objRow.Email#>" />
        <#}#>
       
       

    </td>  
    <td class="GridViewLabItemStyle" style="text-align:left; width:40px;"><#=objRow.Lavel#></td>
   
</tr> 
  <#}#>
</tbody>
</table>   
    </script>
      </div>
            <div style="text-align: center;margin-top: 7px;border-top: 1px solid #ccc;padding-top: 5px;">
 <button id="btnNotification" class="ui-button ui-widget ui-corner-all" onclick="SendNotification()">
    <span class="ui-icon ui-icon-gear"></span> Send
  </button>
          </div>
     
</div>
 


       <div id="Maildialog" title="Send Mail">       
 <div style="width:100%;height:142px;" >

    <input type="hidden" value="0" id="mailSubcategoryID" />
         <input type="hidden" value="0" id="mailCenterID" />
     <input type="hidden" value="0" id="mailTicketNo" />
      <input type="hidden" value="" id="mailGroup" />
         <input type="hidden" value="" id="mailCategory" />
     <input type="hidden" value="" id="mailSubCategory" />
      <input type="hidden" value="" id="mailSinNo" />
         <input type="hidden" value="" id="mailUHIDNo" />
     <input type="hidden" value="" id="mailTestName" />
      <input type="hidden" value="" id="mailSubject" />
         <input type="hidden" value="" id="mailMessage" />           

    

  
  <fieldset  style="float:left; width:94%;height:54px">
    <legend>To: E-Mail / Employee Name </legend>
    <input type="text" name="ToReEmailID" id="ToReEmailID" class="CustomEmail" style="width:616px;height:auto" />
  </fieldset>

      <fieldset  style="float:left; width:94%;height:54px">
    <legend>Cc: E-Mail / Employee Name </legend>
    
   <input type="text" name="CcReEmailID" id="CcReEmailID" class="CustomEmail" style="width:616px;height:auto" />
  </fieldset>
     </div>
        
     
            <div style="text-align: right;margin-top: 7px;border-top: 0px solid #ccc;padding-top: 5px;">
                <em><span style="color: #0000ff; font-size: 8.5pt; float:left;">
                       (use commas as separating multiple email recipients)</span></em>
 <button id="btnsendmail" class="ui-button ui-widget ui-corner-all" onclick="SendMail()">
    <span class="ui-icon ui-icon-gear"></span> Send
  </button>
          </div>
<div id="empautolist"></div>
     
</div>





    <script type="text/javascript">
        var FromDate = "";
        var Todate = "";
        var IssueNo = "";
        var VialId = "";
        var RegNo = "";
        var PccNo = "";
        var modal = "";
        var span = "";
        var Status = "";
        var EmployeeData = "";
        /* use for show per page data come from appseting in webcinfig */

        jQuery(function () {
            bindGroup();
            bindstatus();
        });

        function bindstatus() {

            $.ajax({
                url: "ViewTicket.aspx/GetStatus",
                data: {},
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {

                    $('#ddlStatus').empty();
                    var count = result.length;

                    PatientData = jQuery.parseJSON(result.d);

                    $('#ddlStatus').append($("<option></option>").val("").html(""));
                    dropvale = $("#ddlPanel option:selected").val();

                    for (var a = 0; a <= PatientData.length - 1; a++) {
                        $('#ddlStatus').append($("<option></option>").val(PatientData[a].STATUS).html(PatientData[a].STATUS));
                    }

                    getdataList();

                },
                error: function (xhr, status) {
                    alert("Error.... ");
                }
            });
        }
        function bindGroup() {
            jQuery.ajax({
                url: "../CallCenter/Services/CallCenter.asmx/BindGroup",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    var Group = jQuery.parseJSON(result.d);
                    jQuery("#ddlgroup").append(jQuery("<option></option>").val("").html(""));
                    for (i = 0; i < Group.length; i++) {
                        $("#ddlgroup").append(jQuery("<option></option>").val(Group[i].GroupID).html(Group[i].GroupName));
                    }
                },
                error: function (xhr, status) {
                }
            });
        }
        function Search() {
            getdataList();
        }
    </script>
    <script type="text/javascript">
        function getdataList(filterStatus, Type) {
            FromDate = $('#<%=txtFormDate.ClientID%>').val();
            Todate = $('#<%=txtToDate.ClientID%>').val();
            IssueNo = $('#<%=txtIssueNo.ClientID%>').val();
            FromBarcode = $("#<%=txtFromBarcode.ClientID%>").val();
            ToBarcode = $("#<%=txtToBarcode.ClientID%>").val();
            VialId = $('#<%=txtVialId.ClientID%>').val();
            RegNo = $('#<%=txtRegNo.ClientID%>').val();
            PccNo = $('#<%=txtPcc.ClientID%>').val();

            Status = $('#ddlStatus').val();
            $('#searchid').attr('disabled', true).val('Searching');
            $.ajax({
                url: "ViewTicket.aspx/GetIssueList",
                data: JSON.stringify({ FromDate: FromDate, ToDate: Todate, IssueCode: IssueNo, VialId: VialId, FromBarcode: FromBarcode, ToBarcode: ToBarcode, RegNo: RegNo, PccCode: PccNo, Status: Status, TimeFrm: $("#<%=txtFromTime.ClientID%>").val(), TimeTo: $("#<%=txtToTime.ClientID%>").val(), GroupID: $('#ddlgroup').val() }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (data) {
                    var NewRecord = "";
                    var ResolvedRecord = "";
                    var OldRecord = "";
                    var res = $.parseJSON(data.d);
                    if (res.length == 0) {
                        $('#NewRecord').hide();
                        $('#ResolvedRecord').hide();
                        $('#OldRecord').hide();
                    }

                    if (filterStatus != undefined && Type == "New") {
                        NewRecord = $.grep(res, function (element, index) {
                            return element.Status == "New" && element.IsRead == filterStatus;
                        });
                    }
                    else {
                        NewRecord = $.grep(res, function (element, index) {
                            return element.Status == "New";
                        });
                    }

                    if (filterStatus != undefined && Type == "Old") {
                        OldRecord = $.grep(res, function (element, index) {
                            if (filterStatus == "1")
                                return (element.Status != "New" && element.Status != "Resolved" && element.IsRead == filterStatus);
                            else if (filterStatus == "0") {
                                return (element.Status != "New" && element.Status != "Resolved" && element.IsRead == filterStatus);
                            }
                            else
                                return (element.Status != "New" && element.Status != "Resolved" && element.Status == filterStatus);
                        });
                    }
                    else {
                        OldRecord = $.grep(res, function (element, index) {
                            return (element.Status != "New" && element.Status != "Resolved");
                        });
                    }

                    if (filterStatus != undefined && Type == "Close") {
                        ResolvedRecord = $.grep(res, function (element, index) {
                            return element.Status == "Resolved" && element.IsRead == filterStatus;
                        });
                    }
                    else {
                        ResolvedRecord = $.grep(res, function (element, index) {
                            return element.Status == "Resolved";
                        });
                    }



                    var table = $('#datatable').DataTable();
                    var table1 = $('#datatable1').DataTable();
                    var table2 = $('#datatable2').DataTable();

                    if (NewRecord.length > 0) {
                        $('#NewRecord').show();
                        $('#NewRecordnotfound').hide();
                        table.destroy();
                        table = $('#datatable').DataTable({
                            "scrollY": "300px",
                            "scrollX": true,
                            data: NewRecord,
                            "language": {
                                "info": "Showing _START_ to _END_ of _TOTAL_ records",
                                "infoEmpty": "Showing 0 to 0 of 0 entries",
                                "infoFiltered": "(filtered from _MAX_ total records)",
                                "infoPostFix": "",
                                "thousands": ",",
                                "lengthMenu": "Show _MENU_ records",
                                "loadingRecords": "Loading...",
                                "processing": "Processing...",
                                "search": "Search:",
                                "zeroRecords": "No matching records found",
                                "paginate": {
                                    "first": "First",
                                    "last": "Last",
                                    "next": "Next",
                                    "previous": "Previous"
                                },
                                "aria": {
                                    "sortAscending": ": activate to sort column ascending",
                                    "sortDescending": ": activate to sort column descending"
                                }
                            },
                            "rowCallback": function (row, data, index) {
                                if (data.IsRead == "0") {
                                    $('td', row).css('background-color', '#ffffff');
                                }
                                else {
                                    if (data.Status == "Reply") {
                                        $('td', row).css('background-color', '#6993ca');
                                    }
                                    if (data.Status == "Acknowledge") {
                                        $('td', row).css('background-color', '#ffd2d2');
                                    }
                                    if (data.Status == "Initial Reply") {
                                        $('td', row).css('background-color', '#b3b9c0');
                                    }
                                    if (data.Status == "Assign") {
                                        $('td', row).css('background-color', '#00cccc');
                                    }
                                    if (data.Status == "ReOpen") {
                                        $('td', row).css('background-color', '#ccffcc');
                                    }
                                    if (data.Status == "New") {
                                        $('td', row).css('background-color', '#768aa3');
                                    }
                                    if (data.Status == "Resolved") {
                                        $('td', row).css('background-color', '#ff7f24');
                                    }
                                }


                            },
                            "order": [[0, "desc"]],
                            "columnDefs": [
                                {
                                    "targets": [0],
                                    "visible": false,
                                    "searchable": false
                                },
                                  { "width": "200px!important", "targets": 7 }
                            ],
                            columns: [
                                 { 'data': 'ID', "orderable": "true" },
                                {
                                    data: "ID", "bSearchable": true,
                                    bSortable: true,
                                    mRender: function (data, type, row) {
                                        attach = parseInt(row.Attachment) > 0 ? ' <img src="../../App_Images/attachment.png" style="width: 16px;" />' : '';
                                        return '' + attach + ' <a href="#" class="mailto"><img src="../../App_Images/gmail.png" style="width: 21px;" /></a>&nbsp;&nbsp;<a href="AnswerTicket.aspx?TicketId=' + data + '"" target="_blank" style="curser:pointer;font-size: 18px;" >' + data + '</a>'
                                    }
                                },
                                 {
                                     data: "Status", "bSearchable": true,
                                     bSortable: true,
                                     mRender: function (data, type, row) {
                                         var notify = '';
                                         if (row.Lavel != "0") {
                                             notify = '<a href="#" class="Notify"><img src="../../App_Images/notification.png" style="width: 21px;" /></a>';
                                         }
                                         return '' + data + ' ' + notify + ' '
                                     }
                                 },
                                { 'data': 'GroupName', "orderable": "true" },
                                { 'data': 'CategoryName', "orderable": "true" },
                                { 'data': 'SubCategoryName', "orderable": "true" },
                                { 'data': 'Subject', "orderable": "true" },
                                { 'data': 'Message', "orderable": "true" },
                                { 'data': 'VialId', "orderable": "true" },
                                { 'data': 'RegNo', "orderable": "true" },
                                { 'data': 'Centre', "orderable": "true" },
                                { 'data': 'typeName', "orderable": "true" },
                                { 'data': 'EmpName', "orderable": "true" },
                                { 'data': 'dtAdd', "orderable": "true" },
                                { 'data': 'ElapsedTime', "orderable": "true" }
                            ]
                        });
                    }
                    else {
                        $('#NewRecord').hide();
                        $('#NewRecordnotfound').show();
                        table.destroy();
                    }

                    if (OldRecord.length > 0) {
                        $('#OldRecord').show();
                        $('#OldRecordnotfound').hide();
                        table1.destroy();
                        table1 = $('#datatable1').DataTable({
                            data: OldRecord,
                            "language": {
                                "info": "Showing _START_ to _END_ of _TOTAL_ records",
                                "infoEmpty": "Showing 0 to 0 of 0 entries",
                                "infoFiltered": "(filtered from _MAX_ total records)",
                                "infoPostFix": "",
                                "thousands": ",",
                                "lengthMenu": "Show _MENU_ records",
                                "loadingRecords": "Loading...",
                                "processing": "Processing...",
                                "search": "Search:",
                                "zeroRecords": "No matching records found",
                                "paginate": {
                                    "first": "First",
                                    "last": "Last",
                                    "next": "Next",
                                    "previous": "Previous"
                                },
                                "aria": {
                                    "sortAscending": ": activate to sort column ascending",
                                    "sortDescending": ": activate to sort column descending"
                                }
                            },
                            "scrollX": true,
                            "scrollY": "300px",
                            "rowCallback": function (row, data, index) {
                                if (data.IsRead == "0") {
                                    $('td', row).css('background-color', '#ffffff');
                                }
                                else {
                                    if (data.Status == "Reply") {
                                        $('td', row).css('background-color', '#6993ca');
                                    }
                                    if (data.Status == "Acknowledge") {
                                        $('td', row).css('background-color', '#ffd2d2');
                                    }
                                    if (data.Status == "Initial Reply") {
                                        $('td', row).css('background-color', '#b3b9c0');
                                    }
                                    if (data.Status == "Assign") {
                                        $('td', row).css('background-color', '#00cccc');
                                    }
                                    if (data.Status == "ReOpen") {
                                        $('td', row).css('background-color', '#ccffcc');
                                    }
                                    if (data.Status == "New") {
                                        $('td', row).css('background-color', '#768aa3');
                                    }
                                    if (data.Status == "Resolved") {
                                        $('td', row).css('background-color', '#ff7f24');
                                    }
                                }
                            },                            
                            "order": [[14, "desc"]],
                            "columnDefs": [
                                {
                                    "targets": [15],
                                    "visible": false,
                                    "searchable": false
                                },
                            { "width": "10px", "targets": 0 },
                             { "width": "150px", "targets": 7 }
                            ],
                            columns: [
                                {
                                    "class": 'details-control',
                                    "orderable": false,
                                    "data": null,
                                    "defaultContent": ''
                                },
                                {
                                    data: "ID", "bSearchable": true,
                                    bSortable: true,
                                    mRender: function (data, type, row) {
                                        attach = parseInt(row.Attachment) > 0 ? ' <img src="../../App_Images/attachment.png" style="width: 16px;" />' : '';
                                        return '' + attach + ' <a href="#" class="mailto"><img src="../../App_Images/gmail.png" style="width: 21px;" /></a>&nbsp;&nbsp;<a href="AnswerTicket.aspx?TicketId=' + data + '"" target="_blank" style="curser:pointer;font-size: 18px;" >' + data + '</a>'
                                    }
                                },
                                 {
                                     data: "Status", "bSearchable": true,
                                     bSortable: true,
                                     mRender: function (data, type, row) {
                                         var notify = '';
                                         if (row.Lavel != "0") {
                                             notify = '<a href="#" class="Notify"><img src="../../App_Images/notification.png" style="width: 21px;" /></a>';
                                         }
                                         return '' + data + ' ' + notify + ' '
                                     }
                                 },
                                { 'data': 'GroupName', "orderable": "true" },
                                { 'data': 'CategoryName', "orderable": "true" },
                                { 'data': 'SubCategoryName', "orderable": "true" },
                                { 'data': 'Subject', "orderable": "true" },
                                { 'data': 'Message', "orderable": "true"},
                                { 'data': 'VialId', "orderable": "true" },
                                { 'data': 'RegNo', "orderable": "true" },
                                { 'data': 'Centre', "orderable": "true" },
                                { 'data': 'typeName', "orderable": "true" },
                                { 'data': 'EmpName', "orderable": "true" },
                                { 'data': 'dtAdd', "orderable": "true" },
                                { 'data': 'ElapsedTime', "orderable": "true" },
                                { 'data': 'ElapsedTimeDiffInSec', "orderable": "true" }
                            ]
                        });
                    }
                    else {
                        $('#OldRecord').hide();
                        $('#OldRecordnotfound').show();
                        table1.destroy();
                    }
                    if (ResolvedRecord.length > 0) {
                        $('#Resolvednotfound').hide();
                        $('#ResolvedRecord').show();
                        table2.destroy();
                        table2 = $('#datatable2').DataTable({
                            data: ResolvedRecord,
                            "language": {
                                "info": "Showing _START_ to _END_ of _TOTAL_ records",
                                "infoEmpty": "Showing 0 to 0 of 0 entries",
                                "infoFiltered": "(filtered from _MAX_ total records)",
                                "infoPostFix": "",
                                "thousands": ",",
                                "lengthMenu": "Show _MENU_ records",
                                "loadingRecords": "Loading...",
                                "processing": "Processing...",
                                "search": "Search:",
                                "zeroRecords": "No matching records found",
                                "paginate": {
                                    "first": "First",
                                    "last": "Last",
                                    "next": "Next",
                                    "previous": "Previous"
                                },
                                "aria": {
                                    "sortAscending": ": activate to sort column ascending",
                                    "sortDescending": ": activate to sort column descending"
                                }
                            },
                            "scrollX": true,
                            "scrollY": "300px",
                            "rowCallback": function (row, data, index) {
                                if (data.IsRead == "0") {
                                    $('td', row).css('background-color', '#ffffff');
                                }
                                else {
                                    if (data.Status == "Reply") {
                                        $('td', row).css('background-color', '#6993ca');
                                    }
                                    if (data.Status == "Acknowledge") {
                                        $('td', row).css('background-color', '#ffd2d2');
                                    }
                                    if (data.Status == "Initial Reply") {
                                        $('td', row).css('background-color', '#b3b9c0');
                                    }
                                    if (data.Status == "Assign") {
                                        $('td', row).css('background-color', '#00cccc');
                                    }
                                    if (data.Status == "ReOpen") {
                                        $('td', row).css('background-color', '#ccffcc');
                                    }
                                    if (data.Status == "New") {
                                        $('td', row).css('background-color', '#768aa3');
                                    }
                                    if (data.Status == "Resolved") {
                                        $('td', row).css('background-color', '#768aa3');
                                    }
                                }
                            },
                            "order": [[16, "desc"]],
                            "columnDefs": [
                             {
                                 "targets": [16],
                                 "visible": false,
                                 "searchable": false
                             },
                            { "width": "10px", "targets": 0 },
                            { "width": "150px", "targets": 7 }
                            ],
                            columns: [
                                 {
                                     "class": 'details-control',
                                     "orderable": false,
                                     "data": null,
                                     "defaultContent": ''
                                 },

                                {
                                    data: "ID", "bSearchable": true,
                                    bSortable: true,
                                    mRender: function (data, type, row) {  
                                        attach = parseInt(row.Attachment) > 0 ? ' <img src="../../App_Images/attachment.png" style="width: 16px;" />' : '';
                                        return '' + attach + ' <a href="#" class="mailto"><img src="../../App_Images/gmail.png" style="width: 21px;" /></a>&nbsp;&nbsp;<a href="AnswerTicket.aspx?TicketId=' + data + '"" target="_blank" style="curser:pointer;font-size: 18px;" >' + data + '</a>'
                                    }
                                },
                                 {
                                     data: "Status", "bSearchable": true,
                                     bSortable: true,
                                     mRender: function (data, type, row) {
                                         var notify = '';
                                         if (row.Lavel != "0") {
                                             notify = '<a href="#" class="Notify"><img src="../../App_Images/notification.png" style="width: 21px;" /></a>';
                                         }
                                         return '' + data + ' ' + notify + ' '
                                     }
                                 },                               
                                  { 'data': 'GroupName', "orderable": "true" },
                                { 'data': 'CategoryName', "orderable": "true" },
                                { 'data': 'SubCategoryName', "orderable": "true" },
                                { 'data': 'Subject', "orderable": "true" },
                                { 'data': 'Message', "orderable": "true" },

                                 { 'data': 'VialId', "orderable": "true" },
                                 { 'data': 'RegNo', "orderable": "true" },
                                 { 'data': 'Centre', "orderable": "true" },
                                 { 'data': 'typeName', "orderable": "true" },
                                 { 'data': 'EmpName', "orderable": "true" },
                                 { 'data': 'dtAdd', "orderable": "true" },
                                  { 'data': 'ResolvedBy', "orderable": "true" },
                                { 'data': 'ResolvedDate', "orderable": "true" },
                                 { 'data': 'TATTimeDiffInSec', "orderable": "true" }
                            ]
                        });
                    }
                    else {
                        $('#ResolvedRecord').hide();
                        table2.destroy();
                        $('#Resolvednotfound').show();
                    }

                    $('#datatable,#datatable1,#datatable2').find('tbody').off('click', 'tr td .mailto');
                    $('#datatable,#datatable1,#datatable2').find('tbody').on('click', 'tr td .mailto', function () {
                        table = $('#datatable').DataTable();
                        table1 = $('#datatable1').DataTable();
                        table2 = $('#datatable2').DataTable();
                        var data = "";
                        if ($(this).closest("table").attr("id") == "datatable") {

                            var data = table.row($(this).parent("td")).data();
                        }
                        if ($(this).closest("table").attr("id") == "datatable1") {

                            var data = table1.row($(this).parent("td")).data();
                        }
                        if ($(this).closest("table").attr("id") == "datatable2") {

                            var data = table2.row($(this).parent("td")).data();
                        }
                        if (data != "") {
                            //var body = 'Hi ' + data.EmpName + ',%0D%0A %0D%0A';
                            //body += 'TICKET NO : ' + data.ID + '%0D%0A';
                            //body += 'GROUP : ' + data.GroupName + '%0D%0A';
                            //body += 'CATRGORY : ' + data.CategoryName + '%0D%0A';
                            //body += 'SUBCATEGORY : ' + data.SubCategoryName + '%0D%0A';
                            //if ($.trim(data.VialId) != "")
                            //    body += 'SIN NO. : ' + data.VialId + '%0D%0A';
                            //if ($.trim(data.RegNo) != "")
                            //    body += 'UHID NO. : ' + data.RegNo + '%0D%0A';
                            //if ($.trim(data.typeName) != "")
                            //    body += 'TEST NAME. : ' + data.typeName + '%0D%0A';
                            //body += 'QUERY : ' + data.Message + '%0D%0A %0D%0A %0D%0A %0D%0A %0D%0A %0D%0A %0D%0A';
                            //body += 'This is an automatically generated email. please do not reply to it . %0D%0A';
                            //var subject = data.Subject + "  TICKET No:" + data.ID + "  Date: " + data.dtAdd;
                            //var Email = data.Email;
                            //document.location = "mailto:" + Email + "?subject=" + subject + "&body=" + body + "";
                            //document.location = "mailto:";

                            $('#mailCenterID').val(data.centreID);
                            $('#mailSubcategoryID').val(data.SubCategoryID);
                            $('#mailTicketNo').val(data.ID);
                            $('#mailGroup').val(data.GroupName);
                            $('#mailCategory').val(data.CategoryName);
                            $('#mailSubCategory').val(data.SubCategoryName);
                            $('#mailSinNo').val(data.VialId);
                            $('#mailUHIDNo').val(data.RegNo);
                            $('#mailTestName').val(data.typeName);
                            $('#mailSubject').val(data.Subject + "  TICKET No:" + data.ID + "  Date: " + data.dtAdd);
                            $('#mailMessage').val(data.Message);
                            var title = "<div style='font-weight: normal;'>Ticket No:&nbsp;<b>" + data.ID + "</b>&nbsp;&nbsp;&nbsp; Raised By:&nbsp;<b>" + data.EmpName + "</b>&nbsp;&nbsp;&nbsp;<br/> Raised Location:&nbsp;<b>" + data.Centre + "</b></div>";
                            $("#Maildialog").dialog("open");
                            $(".ui-dialog-title").html(title);
                            return false;

                        }
                    });
                    $('#datatable1').find('tbody').off('click', 'tr td.details-control');
                    $('#datatable1').find('tbody').on('click', 'tr td.details-control', function () {
                        var tr = $(this).closest('tr');
                        var row = table1.row(tr);
                        if (row.child.isShown()) {
                            // This row is already open - close it
                            $('div.slider', row.child()).slideUp(function () {
                                row.child.hide();
                                tr.removeClass('shown');
                            });
                        }
                        else {
                            // Open this row
                            row.child(format(row.data()), 'no-padding').show();
                            tr.addClass('shown');
                            $('div.slider', row.child()).slideDown();
                        }
                    });

                    $('#datatable2').find('tbody').off('click', 'tr td.details-control');
                    $('#datatable2').find('tbody').on('click', 'tr td.details-control', function () {
                        var tr = $(this).closest('tr');
                        var row = table2.row(tr);
                        if (row.child.isShown()) {
                            // This row is already open - close it
                            $('div.slider', row.child()).slideUp(function () {
                                row.child.hide();
                                tr.removeClass('shown');
                            });
                        }
                        else {
                            // Open this row
                            row.child(format(row.data()), 'no-padding').show();
                            tr.addClass('shown');
                            $('div.slider', row.child()).slideDown();
                        }
                    });

                    function format(d) {
                        BindReplyes(d.ID);
                        var data = $('#divReplyOutput').html();
                        return data;

                    }
                    $('#datatable,#datatable1,#datatable2').find('tbody').off('click', 'tr td .Notify');
                    $('#datatable,#datatable1,#datatable2').find('tbody').on('click', 'tr td .Notify', function () {
                        table = $('#datatable').DataTable();
                        table1 = $('#datatable1').DataTable();
                        table2 = $('#datatable2').DataTable();
                        var data = "";
                        if ($(this).closest("table").attr("id") == "datatable") {

                            var data = table.row($(this).parent("td")).data();
                        }
                        if ($(this).closest("table").attr("id") == "datatable1") {

                            var data = table1.row($(this).parent("td")).data();
                        }
                        if ($(this).closest("table").attr("id") == "datatable2") {

                            var data = table2.row($(this).parent("td")).data();
                        }
                        if (data != "") {
                            $('#CenterID').val(data.centreID);
                            $('#SubcategoryID').val(data.SubCategoryID);
                            $('#TicketNo').val(data.ID);

                            $('#Group').val(data.GroupName);
                            $('#Category').val(data.CategoryName);
                            $('#SubCategory').val(data.SubCategoryName);
                            $('#SinNo').val(data.VialId);
                            $('#UHIDNo').val(data.RegNo);
                            $('#TestName').val(data.typeName);
                            $('#Subject').val(data.Subject + "  Ticket No.:" + data.ID + "  Date: " + data.dtAdd);
                            $('#Message').val(data.Message);
                            $('#smstempTicket').text(data.ID);
                            var title = "<div style='font-weight: normal;'>Ticket No.:&nbsp;<b>" + data.ID + "</b>&nbsp;&nbsp;&nbsp; Raised By:&nbsp;<b>" + data.EmpName + "</b>&nbsp;&nbsp;&nbsp; Raised Location:&nbsp;<b>" + data.Centre + "</b></div>";
                            $("#dialog").dialog("open");
                            $(".ui-dialog-title").html(title);
                            return false;    
                        }
                    });
                    if (Status == "New" && NewRecord.length > 0) {
                        $('#NewRecord').show();
                        $('#ResolvedRecord').hide();
                        $('#OldRecord').hide();
                    }
                    else if ((Status == "Acknowledge" || Status == "Reply" || Status == "Initial Reply" || Status == "Assign" || Status == "ReOpen" || Status == "Closed") && OldRecord.length > 0) {
                        $('#OldRecord').show();
                        $('#NewRecord').hide();
                        $('#ResolvedRecord').hide();

                    }
                    else if (Status == "Resolved" && ResolvedRecord.length > 0) {
                        $('#ResolvedRecord').show();
                        $('#NewRecord').hide();
                        $('#OldRecord').hide();
                    }
                    else {
                        if (NewRecord.length > 0)
                            $('#NewRecord').show();
                        if (OldRecord.length > 0)
                            $('#OldRecord').show();
                        if (ResolvedRecord.length > 0)
                            $('#ResolvedRecord').show();
                    }
                }
            });


            $('#searchid').removeAttr('disabled').val('Search');
        }

    </script>
     <script type="text/javascript">
         function BindReplyes(TicketID) {
             jQuery.ajax({
                 url: "AnswerTicket.aspx/GetReply",
                 data: '{ TicketId: "' + TicketID + '"}',
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 async: false,
                 success: function (result) {
                     ReplyData = $.parseJSON(result.d);

                     jQuery('#divReplyOutput').html('');
                     var output = jQuery('#tb_Reply').parseTemplate(ReplyData);
                     jQuery('#divReplyOutput').html(output);
                 },
                 error: function (xhr, status) {

                 }
             });


         }
    </script>

     <script type="text/javascript">
         $(document).on("mouseenter", "a.im", function (e) {
             var url = $(this).attr("url");
             var ext = url.substring(url.lastIndexOf(".") + 1);
             if (ext != "doc" && ext != "docx") {
                 openpopup(url)
             }
         });
         function openpopup(FilePath) {
             window.open('image.aspx?FilePath=' + FilePath, null, 'left=150, top=100, height=350, width=810, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');
         }
    </script>
     <script type="text/javascript">
         $(function () {
             $("#dialog").dialog({
                 autoOpen: false,
                 height: 560,
                 width: 800,
                 modal: true,
                 resizable: false,
                 draggable: false,
                 closeOnEscape: true,
                 //position: 'top',
                 show: {
                     effect: "blind",
                     duration: 1000
                 },
                 hide: {
                     effect: "explode",
                     duration: 1000
                 },
                 close: function () {
                     jQuery('#divNotifyOutput').html('');
                     $('#CenterID').val("0");
                     $('#SubcategoryID').val("0");
                     $('.checkbox').prop('checked', false).button("refresh");
                     $('#TicketNo').val("0");
                     $('#Group').val('');
                     $('#Category').val('');
                     $('#SubCategory').val('');
                     $('#SinNo').val('');
                     $('#UHIDNo').val('');
                     $('#TestName').val('');
                     $('#Subject').val('');
                     $('#Message').val('');                     
                     $('#msg').val('');
                     $('#msgmail').val('');

                     $('#divSMS').hide();
                     $('#divmailSMS').show();
 
                     $('#radioNotifyEmail').prop('checked', true).button("refresh");
                     $('#smsNotify').prop('checked', false).button("refresh");
                    
                     
                 }
             });
             $(function () {
                 $(".ChkRto").checkboxradio();
             });


         });
  </script>

        <script type="text/javascript">

            $(document).on('change', '.checkbox', function () {
                getNotify();                
            });

            $(document).on('change', '.ChkRto', function () {
                getNotify();

            });

            function getNotify() {
                var Type
                $('input[type=radio]').each(function () {
                    if (this.checked) {
                        if ($(this).attr("id") == "smsNotify") {
                            Type = "SMS";                             
                            $('#msg').val('');
                            $('#msgmail').val('');
                            $('#divSMS').show();
                            $('#divmailSMS').hide();  
                        }
                        else {
                            Type = "Email";                          
                            $('#msg').val('');
                            $('#msgmail').val('');                            
                            $('#divSMS').hide();
                            $('#divmailSMS').show();
                        }
                    }
                });
                var level = "";
                $('input[type=checkbox]').each(function () {
                    if (this.checked) {
                        level = level + "'" + $(this).attr("id") + "'" + ",";
                    }
                });
                var CenterID = $('#CenterID').val();
                var SubCategoryID = $('#SubcategoryID').val();
                GetNotifyEmployee(CenterID, SubCategoryID, level, Type);

            }

            function GetNotifyEmployee(CenterID, SubCategoryID, level, Type) {

                jQuery.ajax({
                    url: "ViewTicket.aspx/GetNotifyEmployee",
                    data: '{ CenterID: "' + CenterID + '",SubcategoryID: "' + SubCategoryID + '",Lavel: "' + level + '",Type:"' + Type + '"}',
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        EmployeeData = $.parseJSON(result.d);

                        jQuery('#divNotifyOutput').html('');
                        var output = jQuery('#tb_Notify').parseTemplate(EmployeeData);
                        jQuery('#divNotifyOutput').html(output);

                        if (Type == "SMS") {
                            $("#EmailMobile").html('Mobile No');
                        }
                        else {

                            $("#EmailMobile").html('E-mailID');
                        }
                    },
                    error: function (xhr, status) {

                    }
                });


            }
            function isValidEmailAddress(emailAddress) {
                var pattern = new RegExp(/^[+a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/i);

                return pattern.test(emailAddress);
            };

            function IsValidMobile(mobile) {               
                var pattern = /^\d{10}$/;
                if (pattern.test(mobile)) {                    
                    return true;
                }                
                else
                return false;
            }

            function SendNotification() {
                var EmailID = ""
                var IsVailid = true;
                var Count = 0;
                var Type = "";
                $('input[type=radio]').each(function () {
                    if (this.checked) {
                        if ($(this).attr("id") == "smsNotify") {
                            Type = "SMS";
                        }
                        else {
                            Type = "Email";
                        }
                    }
                });

                if (Type == "SMS") {
                    if ($('#msg').val() == "") {
                        alert("Please Emter Comments..!");
                        $('#msg').focus();
                        return;
                    }
                }
                if (Type == "Email") {
                    if ($('#msgmail').val() == "") {
                        alert("Please Emter Message..!");
                        $('#msgmail').focus();
                        return;
                    }
                }
               

                var TicketNo = $('#TicketNo').val();
                if ($("#tbl_Notify tbody").find('tr').length == 0) {
                    alert("Employee does not exist..!");
                    return;
                }

                $("#tbl_Notify tbody").find('tr').each(function (i) {
                    if ($(this).find(".empcheckbox").is(":checked")) {
                        Count = Count + 1
                    }
                });

                if (Count == 0) {
                    alert("Please Check an employee ..!");
                    return;
                }                
                 
                    $("#tbl_Notify tbody").find('tr').each(function (i) {
                        if ($(this).find(".empcheckbox").is(":checked")) {
                            if ($.trim($(this).find(".Email").val()) != "")
                                if (Type == "SMS") {
                                    if (IsValidMobile($(this).find(".Email").val())) {
                                        EmailID = EmailID + $(this).find(".Email").val() + ",";
                                    }
                                    else {
                                        alert("Invalid Mobile Number..!");
                                        $(this).find(".Email").focus();
                                        IsVailid = false;
                                        return false;
                                    }
                                }
                                else {
                                    if (isValidEmailAddress($(this).find(".Email").val())) {
                                        EmailID = EmailID + $(this).find(".Email").val() + ",";
                                    }
                                    else {
                                        alert("Invalid email address..!");
                                        $(this).find(".Email").focus();
                                        IsVailid = false;
                                        return false;
                                    }
                                }
                        }
                    });
                

                if (!IsVailid)
                    return;

                var obj = new Object();
                obj.TicketID = $('#TicketNo').val();
                obj.Group = $('#Group').val();
                obj.Category = $('#Category').val();
                obj.SubCategory = $('#SubCategory').val();
                obj.SinNo = $('#SinNo').val();
                obj.UHIDNo = $('#UHIDNo').val();
                obj.TestName = $('#TestName').val();
                obj.Subject = $('#Subject').val();

                obj.Email = EmailID;                 
                obj.Type = Type
                if (Type == "SMS") {
                    var msg='Please look into the Ticket No '+$('#TicketNo').val()+' on urgent basis.';
                    msg = msg + ' ' + 'Comments:' + $('#msg').val() + '';
                    obj.Message = msg;
                }
                else {
                    obj.Message = $('#msgmail').val();
                }

                jQuery('#btnNotification').attr('disabled', 'disabled');
                jQuery.ajax({
                    url: "ViewTicket.aspx/SendNotification",
                    data: JSON.stringify({ Data: JSON.stringify(obj) }),
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        if (result.d == "1") {
                            alert("mail sent successfully");
                            jQuery('#btnNotification').removeAttr('disabled');
                            $("#dialog").dialog("close");

                        }
                        else if (result.d == "2") {
                            alert("Sms sent successfully");
                            jQuery('#btnNotification').removeAttr('disabled');
                            $("#dialog").dialog("close");

                        }
                        else {
                            jQuery('#btnNotification').removeAttr('disabled');
                            alert("mail send failed");
                        }

                    },
                    error: function (xhr, status) {
                        jQuery('#btnNotification').removeAttr('disabled');
                    }
                });
            }
    </script>

      <script type="text/javascript">
          var length = $("#smstemplate").text().length + $("#smslevel").text().length
          var MaxLength = 160 - length;
          jQuery(document).ready(function () {
              jQuery("#msg").bind("cut copy paste", function (event) {
                event.preventDefault();
            });
            jQuery("#lblremaingCharacters").html(MaxLength - ($("#msg").val().length));
            jQuery("#msg").bind("keyup keydown", function () {
                 length = $("#smstemplate").text().length + $("#smslevel").text().length
                 MaxLength = 160 - length;

                var characterInserted = $(this).val().length;
                if (characterInserted > MaxLength) {
                    jQuery(this).val(jQuery(this).val().substr(0, MaxLength));
                }
                var characterRemaining = MaxLength - characterInserted;
                jQuery("#lblremaingCharacters").html(characterRemaining);
            });
            jQuery('#msg').bind("keypress", function (e) {
                  length = $("#smstemplate").text().length + $("#smslevel").text().length
                MaxLength = 160 - length;
                // For Internet Explorer  
                if (window.event) {
                    keynum = e.keyCode
                }
                    // For Netscape/Firefox/Opera  
                else if (e.which) {
                    keynum = e.which
                }
                keychar = String.fromCharCode(keynum)
                if (e.keyCode == 39 || keychar == "'") {
                    return false;
                }

                if (jQuery(this).val().length >= MaxLength) {
                    if (keynum == 8) {
                        return true;
                    }
                    else {
                        if (window.event)//IE
                        {
                            e.returnValue = false;
                            return false;
                        }
                        else//Firefox
                        {
                            e.preventDefault();
                            return false;
                        }
                    }

                }
            });
        });
       
        
        

    </script>


     <script type="text/javascript">
         $(function () {
             $("#Maildialog").dialog({
                 autoOpen: false,
                 height: 240,
                 width: 700,
                 modal: true,
                 resizable: false,
                 draggable: false,
                 closeOnEscape: true,
                 //position: 'top',
                 show: {
                     effect: "blind",
                     duration: 1000
                 },
                 hide: {
                     effect: "explode",
                     duration: 1000
                 },
                 close: function () {
                     $('#mailCenterID').val("0");
                     $('#mailSubcategoryID').val("0");
                     $('#mailTicketNo').val("0");
                     $('#mailGroup').val('');
                     $('#mailCategory').val('');
                     $('#mailSubCategory').val('');
                     $('#mailSinNo').val('');
                     $('#mailUHIDNo').val('');
                     $('#mailTestName').val('');
                     $('#mailSubject').val('');
                     $('#mailMessage').val('');
                    
                     $('#ToReEmailID').tokenfield('setTokens', []);
                     $('#ToReEmailID').val('');

                     $('#CcReEmailID').tokenfield('setTokens', []);
                     $('#CcReEmailID').val('');
                 }
             });



         });
  </script>

      <script type="text/javascript">  
          function SendMail() { 
              var EmailAddress = ""
              var CcEmailAddress = ""
              var IsVailid = true; 
              if ($('#ToReEmailID').val() == "") {
                  alert("Please Enter Email Address.!");
                  $("#ToReEmailID").focus();
                  return;
              } 
              var toarray = $('#ToReEmailID').val().split(",");
              $.each(toarray, function (i) {
                  if (isValidEmailAddress($.trim(toarray[i]))) {
                      EmailAddress = EmailAddress + toarray[i] + ",";
                  }
                  else {
                      alert("Invalid To email address..!");
                      $("#ToReEmailID").focus();
                      IsVailid = false;
                      return false;
                  }
              });
              if ($('#CcReEmailID').val() != "") {
                  var ccarray = $('#CcReEmailID').val().split(",");
                  $.each(ccarray, function (i) {
                      if (isValidEmailAddress($.trim(ccarray[i]))) {
                          CcEmailAddress = CcEmailAddress + ccarray[i] + ",";
                      }
                      else {
                          alert("Invalid Cc email address..!");
                          $("#CcReEmailID").focus();
                          IsVailid = false;
                          return false;
                      }
                  });
              }
              if (!IsVailid)
                  return; 
              var obj = new Object();
              obj.TicketID = $('#mailTicketNo').val();
              obj.Group = $('#mailGroup').val();
              obj.Category = $('#mailCategory').val();
              obj.SubCategory = $('#mailSubCategory').val();
              obj.SinNo = $('#mailSinNo').val();
              obj.UHIDNo = $('#mailUHIDNo').val();
              obj.TestName = $('#mailTestName').val();
              obj.Subject = $('#mailSubject').val();
              obj.Message = $('#mailMessage').val(); 
              obj.Email = EmailAddress;
              obj.CcEmail = CcEmailAddress;
              jQuery('#btnsendmail').attr('disabled', 'disabled');
              jQuery.ajax({
                  url: "ViewTicket.aspx/SendMail",
                  data: JSON.stringify({ Data: JSON.stringify(obj) }),
                  type: "POST", // data has to be Posted    	        
                  contentType: "application/json; charset=utf-8",
                  timeout: 120000,
                  dataType: "json",
                  async: false,
                  success: function (result) {
                      if (result.d == "1") {
                          alert("mail sent successfully");
                          jQuery('#btnsendmail').removeAttr('disabled');
                          $("#Maildialog").dialog("close");

                      } 
                      else {
                          jQuery('#btnsendmail').removeAttr('disabled');
                          alert("mail send failed");
                      }

                  },
                  error: function (xhr, status) {
                      jQuery('#btnsendmail').removeAttr('disabled');
                  }
              });
          }
    </script>
     <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-tokenfield/0.12.0/bootstrap-tokenfield.js" type="text/javascript"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-tokenfield/0.12.0/css/bootstrap-tokenfield.css" rel="stylesheet" type="text/css" />

     <script type="text/javascript">


         $(document).ready(function () {
             $("#ToReEmailID").tokenfield({
                 autocomplete: {
                     source: function (request, response) {
                         $.ajax({
                             url: 'ViewTicket.aspx/GetUserList',
                             data: "{ 'q': '" + request.term + "'}",
                             dataType: "json",
                             type: "POST",
                             contentType: "application/json; charset=utf-8",
                             success: function (data) {
                                 var data = $.parseJSON(data.d);
                                 response(data)
                             }
                         });
                     },
                     delay: 100,
                     showAutocompleteOnFocus: false
                 } 
             })


             $('#ToReEmailID').on('tokenfield:createtoken', function (event) {
                 $('#ToReEmailID-tokenfield').blur();
                 $('#ToReEmailID-tokenfield').focus();
                 $('#ToReEmailID-tokenfield').autocomplete('search', '');
                 var existingTokens = $(this).tokenfield('getTokens');                 
                 $.each(existingTokens, function (index, token) {
                     if (token.value === event.attrs.value) {
                         event.preventDefault();
                         $('#ToReEmailID-tokenfield').val('');
                     }
                 });

                 var data = event.attrs.value.split('|')
                 event.attrs.value = data[1] || data[0]
                 event.attrs.label = data[1] ? data[0] + ' (' + data[1] + ')' : data[0]
             });


             $("#CcReEmailID").tokenfield({
                 autocomplete: {
                     source: function (request, response) {
                         $.ajax({
                             url: 'ViewTicket.aspx/GetUserList',
                             data: "{ 'q': '" + request.term + "'}",
                             dataType: "json",
                             type: "POST",
                             contentType: "application/json; charset=utf-8",
                             success: function (data) {
                                 var data = $.parseJSON(data.d);
                                 response(data)
                             }
                         });
                     },
                     delay: 100,
                     showAutocompleteOnFocus: false
                 }
             })
             $('#CcReEmailID').on('tokenfield:createtoken', function (event) {
                 $('#CcReEmailID-tokenfield').blur();
                 $('#CcReEmailID-tokenfield').focus();
                 $('#CcReEmailID-tokenfield').autocomplete('search', '');
                 var existingTokens = $(this).tokenfield('getTokens');
                 $.each(existingTokens, function (index, token) {
                     if (token.value === event.attrs.value) {
                         event.preventDefault();
                         $('#CcReEmailID-tokenfield').val('');
                     }
                 });

                 var data = event.attrs.value.split('|')
                 event.attrs.value = data[1] || data[0]
                 event.attrs.label = data[1] ? data[0] + ' (' + data[1] + ')' : data[0]
             });
         });

    </script>
    <style type="text/css">
        .tokenfield {
    height: auto;
    min-height: 25px;
    padding-bottom: 0px;
    padding: 5px;
    border: 1px solid #ccc;
}
    </style>
 
    <link href="../../App_Style/jquery.dataTables.min.css" rel="stylesheet" />
</asp:Content>

