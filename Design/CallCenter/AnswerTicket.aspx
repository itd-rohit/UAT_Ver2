<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" ClientIDMode="Static" CodeFile="AnswerTicket.aspx.cs" Inherits="Design_CallCenter_AnswerTicket" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <link href="../../App_Style/jquery.timepicker.min.css" rel="stylesheet" />
    <script src="../../Scripts/jquery.timepicker.min.js"></script>
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <style type="text/css">
        .GridViewHeaderStyle {
            height: 30px;
        }

        .GridViewLabItemStyle {
            padding: 6px;
        }

        #tbl_Reply tr:nth-child(even) {
            background: #d7edff!important;
        }

        #tbl_Reply tr:nth-child(odd) {
            background: #FFF!important;
        }
    </style>
    <script type="text/javascript">
        var id = "";
        var ans = "";
        var UserId = "";
        $(document).ready(function () {
            $('#mastertopcorner').hide();
            $('#masterheaderid').hide();
            // CheckReadStatus('<%= Util.GetString(Request.QueryString["TicketId"])%>');

            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': { allow_single_deselect: true },
                '.chosen-select-no-single': { disable_search_threshold: 10 },
                '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chosen-select-width': { width: "100%" }
            }
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }

            jQuery("#<%=ddlQueries.ClientID%>").chosen().change(function () {
                if ($('#<%=ddlQueries.ClientID%> option:selected').val() != "") {
                    $.ajax({
                        type: "POST",
                        async: false,
                        url: "AnswerTicket.aspx/GetQueryDescription",
                        data: JSON.stringify({ QueryId: jQuery('#<%=ddlQueries.ClientID%> option:selected').val(), }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (data) {
                            var Result = jQuery.parseJSON(data.d);
                            jQuery('#<%=txtRply.ClientID%>').val('');
                            if (data.d != "") {
                                jQuery('#<%=txtRply.ClientID%>').val(Result[0].Detail);

                            }
                        },
                        error: function (result) {
                        }
                    });
                }
                else {
                    jQuery('#<%=txtRply.ClientID%>').val('');
                }
            });
            UserId = '<%=Util.GetString(Session["ID"])%>';
            id = '<%=Util.GetString(Request.QueryString["TicketId"])%>';
        });
        function CheckReadStatus(ItemId) {
            jQuery.ajax({
                url: "Services/Support.asmx/CheckReadStatus",
                data: JSON.stringify({ ItemId: ItemId }),
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (data) {

                },
                error: function (data) {

                }
            });
        }
    </script>
    <div id="Pbody_box_inventory" style="width: 1204px;">
       <Ajax:ScriptManager  ID="sc" runat="server"></Ajax:ScriptManager>
        
        <div class="POuter_Box_Inventory" style="width: 1200px;text-align: center">         
                <b>View Support Ticket <asp:Label ID="lblDisplayTicketID" runat="server"  style="font-weight:bold;font-size:large; float:right;"></asp:Label> </b>
                <br />
                <b style="color: red">
                    <asp:Label ID="lblError" runat="server"></asp:Label></b>           
        </div>
        <div class="POuter_Box_Inventory" style="width: 1200px">
         <asp:Label ID="lblCategoryID" runat="server" style="display:none"></asp:Label>
            <asp:Label ID="lblSubCategoryID" runat="server" style="display:none"></asp:Label>
            <asp:Label ID="lblReoprnRight" runat="server" style="display:none"></asp:Label>
                <table style="width: 100%;">
                    <tr>
                        <td style="text-align:right;font-weight:bold;width:12%">Raised by code :&nbsp;</td>
                        <td style="width:22%">
                           <span id="spnEmpID"></span>
                        </td>
                        <td style="text-align:right;font-weight:bold;width:12%">Raised By :&nbsp;</td>
                        <td style="width:22%"><span id="spnEmpName"></span></td>
                        <td style="text-align:right;font-weight:bold;width:10%">Status :&nbsp;</td>
                        <td  style="width:22%"><b><span id="spnStatus"></span></b></td>                       
                    </tr>
                    <tr>
                        <td style="text-align:right;font-weight:bold">Email ID :&nbsp;</td>
                        <td>
                           <span id="spnEmail"></span>
                        </td>
                        <td style="text-align:right; font-weight:bold">Mobile No. :&nbsp;</td>
                        <td ><span id="spnMobile"></span>                            
                        </td>
                        <td style="text-align:right;font-weight:bold">                           
                            Group :&nbsp;</td>
                        <td>                           
                        <span id="spnGroup"></span>
                        </td>
                    </tr>                   
                                  
                    <tr>
                        <td style="text-align:right;font-weight:bold">Client Code :&nbsp;</td>
                        <td>
                           <span id="spnClientCode"></span>
                        </td>
                        <td style="text-align:right; font-weight:bold">Subject :&nbsp;</td>
                        <td ><span id="spnSubject"></span>                            
                        </td>
                        <td style="text-align:right;font-weight:bold">                           
                            Raised Date :&nbsp;</td>
                        <td>                           
                        <span id="spnDate"></span>
                        </td>
                    </tr>                   
                    <tr>
                        <td style="text-align:right;font-weight:bold">Question :&nbsp;</td>
                        <td colspan="5">
                            <div class="messBox" style="overflow: auto; max-height: 200px;">
                               <span id="spnMessage"></span>
                            </div>
                        </td>
                    </tr>
<tr>
                        <td  style="text-align:right;font-weight:bold"><span id="tdVialID"> SIN No. :</span>&nbsp;</td>
                        <td>
                            <span id="spnVialID"></span>
                        </td>
                        <td  style="text-align:right;font-weight:bold"> <span id="tdRegNo">UHID No. :</span>&nbsp;</td>
                        <td><span id="spnRegNo"></span>
                        </td>
                          <td  style="text-align:right;font-weight:bold">                           
                            <span id="tdDepartment">Department : </span>&nbsp;</td>
                        <td>                           
                        <span id="spnDepartment"></span>
                        </td>
                    </tr>  
                </table>                   
        </div>
     
        <div class="POuter_Box_Inventory" style="width: 1200px; height:280px;overflow-y:scroll;">
        <div id="divReplyOutput">
                
            </div>
      
            </div>
            
        <script id="tb_Reply" type="text/html">  
        <table class="GridViewStyle" cellspacing="0" rules="all"  id="tbl_Reply" width="100%" >
		<tr>
			<th class="GridViewHeaderStyle" style="width:40px;" >S.No.</th>
            <th class="GridViewHeaderStyle" style="width:110px; text-align:center;" >Replyed By</th>
            <th class="GridViewHeaderStyle" style="width:120px;">Reply DateTime</th>            
            <th class="GridViewHeaderStyle" style="width:70px;">Attachment</th>          
			<th class="GridViewHeaderStyle" style="width:480px;">Description</th>
            <th class="GridViewHeaderStyle" style="width:130px;">TAT Time</th>
             
         </tr>

       <#
              var dataLength=ReplyData.length;
            
              var objRow;  
            
        for(var j=0;j<dataLength;j++)
        { 
var array=[];
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
       <#for(var i=0; i < array.length; i++){#> 
        <div style="margin-bottom: 10px;"><a class="im" url=" <#=array[i].split("#")[1]#>" style="cursor: pointer" href="../Lab/DownloadAttachment.aspx?FileName= <#=array[i].split("#")[0]#>&Type=3&FilePath=<#=array[i].split("#")[1]#>" target="_blank">
                                <img src="../../App_Images/attachment.png" />
                 <#=array[i].split("#")[0]#>
                              </a></div>
        <#}#>
    </td>
    <td class="GridViewLabItemStyle" style="text-align:left;"><#=objRow.Answer#></td>
  <td class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.TATTime#></td>
</tr> 
  <#}#>

</table> 
             
           
    </script>  
        <div class="POuter_Box_Inventory" style="width: 1200px" runat="server" id="NotForPcc">
            <table width="100%" style="margin-bottom: 1%;">
                <tr>
                    <th style="width: 30%; text-align: right"> Predefined Response :&nbsp;</th>
                    <td style="text-align: left">
                        <asp:DropDownList ID="ddlQueries" runat="server" Width="80%" CssClass="chosen-select" ClientIDMode="Static" onchange="bindDetail()"></asp:DropDownList>
                        <asp:Label ID="lblEncryptTicketID" runat="server" style="display:none" ClientIDMode="Static"></asp:Label>
                        <asp:Label ID="lblTicketID" runat="server" style="display:none" ClientIDMode="Static"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <th style="text-align: right;vertical-align:top">Reply :&nbsp;</th>
                    <td>
                        <asp:TextBox ID="txtRply" TextMode="MultiLine" Rows="5" Style="width: 80%; max-width: 80%" runat="server" ClientIDMode="Static"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th style="text-align: right;vertical-align:top">Status :&nbsp; </th>
                    <td>
                      <asp:DropDownList ID="ddlStatus" Width="120px" runat="server" ClientIDMode="Static" onchange="chkStatus()" >                                                  
                      </asp:DropDownList>
                        &nbsp;&nbsp;
                        <span id="spnEmployee" style="display:none">
                        Employee :&nbsp;<asp:TextBox ID="txtEmployee" runat="server" MaxLength="50" ClientIDMode="Static" Width="180px"></asp:TextBox>
                            <asp:HiddenField ID="hpEmployeeID" runat="server"  ClientIDMode="Static"/>
                        </span> &nbsp;&nbsp;
                        <span id="spnEmployeeEmailID" style="display:none">
                        E-MailID :&nbsp;<asp:TextBox ID="txtEmployeeEmailID" runat="server" MaxLength="50" ClientIDMode="Static" Width="175px"></asp:TextBox>
                           <asp:HiddenField ID="hdnIsEmailID" runat="server"  ClientIDMode="Static"/>
                        </span>

                         <span id="spnrootcause" style="display:none">
                        Root Cause :&nbsp;
                        <asp:DropDownList ID="ddlRootCause" runat="server" Width="220px" TabIndex="2">
                        </asp:DropDownList>
                        <input type="button" value="New" id="btnNewDesignation" onclick="OpenDesignationWindow()"  class="ItDoseButton"/>
                        </span>

                         <span id="spnReopenReason" style="display:none">
                        Reopen Reason :&nbsp;<asp:TextBox ID="txtReopenReason" runat="server" MaxLength="100" ClientIDMode="Static" Width="260px"></asp:TextBox>                            
                        </span> 
                          </td>
                </tr>
                  <tr id="spnOtherEmailId" style="display:none;">
                    <th style="text-align: right;vertical-align:top">
                        Other EmailID :
                    </th>
                    <td>
                         <asp:TextBox ID="txtotheremail" ClientIDMode="Static" runat="server" Width="669px"></asp:TextBox>
                         
                    </td>
                </tr>
                <tr id="spnExpectedResolveDateTime" style="display:none;">
                    <th style="text-align: right;vertical-align:top">
                        Expected Resolve Date :
                    </th>
                    <td>
                         <asp:TextBox ID="txtResolveDate" ClientIDMode="Static" runat="server" Width="117px" ReadOnly="true"></asp:TextBox>
                            <cc1:CalendarExtender ID="calResolveDate" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtResolveDate" />
                          Time : <asp:TextBox ID="txtResolveTime" ClientIDMode="Static" runat="server" Width="70px"></asp:TextBox>
                                <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time" Enabled="True" AutoComplete="true" 
                                TargetControlID="txtResolveTime"  AcceptAMPM="True">
                                </cc1:MaskedEditExtender>
                                <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtResolveTime" 
                                ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required"
                                  InvalidValueMessage="*"  ></cc1:MaskedEditValidator>
                          <em ><span style="color: #0000ff; font-size: 7.5pt">
                       (Type A or P to switch AM/PM)</span></em>
                             
                    </td>
                </tr>
                <tr style="display:none">
                    <th style="text-align: right">Upload File :&nbsp;</th>
                    <td>
                        <asp:FileUpload ID="fu_file" runat="server" />
                    </td>
                </tr>
                <tr>
                    <th style="text-align: right">&nbsp;</th>
                    <td>
                        <asp:Label ID="lblFileName" runat="server" style="display:none;"></asp:Label>
                        <span style="font-weight:bold;"><a href="javascript:void(0)" onclick="showuploadbox()" style="color:blue;">Upload Attachment</a></span>
                        &nbsp; <span style="font-weight: bold;"><a style="color: blue;" href="javascript:void(0)" onclick="showPrintscreen()">Upload Print Screen Attachment</a></span>
                    </td>
                </tr>
            </table>
             </div>
         <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;text-align:center;z-index:initial">
        <p id="msgField" style="color:white;padding:10px;font-weight:bold;"></p>
    </div>
                   <div class="POuter_Box_Inventory" style="width: 1200px;text-align:center">                            
           <input type="button" id="btnSaveReply"  value="Save" onclick="SaveReply()" class="searchbutton"/>&nbsp;&nbsp;
                       <input type="button" id="btnClose"  value="Close" onclick="WindowClose()" class="searchbutton"/>
        </div>
    </div>

  <%--Designation Start--%>
        <asp:Button ID="btnhiddenDesignation" runat="server" Style="display: none" />
        <cc1:ModalPopupExtender ID="Designation" runat="server"
            DropShadow="true" TargetControlID="btnhiddenDesignation" CancelControlID="closeDesignation" BackgroundCssClass="filterPupupBackground"
            PopupControlID="pnldesignation" OnCancelScript="CloseDesignationWindow()" BehaviorID="Designation">
        </cc1:ModalPopupExtender>
        <asp:Panel ID="pnldesignation" runat="server" Style="display: none; width: 350px; height: 110px;" CssClass="pnlVendorItemsFilter">
            <div class="Purchaseheader">
                <table style="width: 100%; border-collapse: collapse" border="0">
                    <tr>
                        <td>Add New RootCause &nbsp;</td>
                        <td style="text-align: right">
                            <img id="closeDesignation" alt="1" src="../../App_Images/Delete.gif" style="cursor: pointer;" />
                        </td>
                    </tr>
                </table>
            </div>
            <table style="width: 100%; border-collapse: collapse">
                <tr>
                    <td colspan="2" style="text-align:center;">
                      &nbsp;  <label for="txtdesignation" id="lblMsgDesignation" class="ItDoseLblError"></label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 100px;text-align:right" >Root Cause :&nbsp;</td>
                    <td style="width: 233px;text-align:left" >
                        <input type="text" id="txtdesignation" style="width: 200px;" value=""  maxlength="50"/>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <div style="text-align: center; ">
                            <input type="button" class="ItDoseButton" onclick="SaveDesignation()" id="btnsaveDesignation" style="" value="Save" />
                            <input type="button" class="ItDoseButton" onclick="CloseDesignationWindow()" id="btncancelDesignation" style="" value="Cancel" />
                        </div>
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <%--Designation End--%>
    
    <script type="text/javascript">
        function WindowClose() {
            window.close();
        }
        var ReplyData = "";
        jQuery(function () {

            BindReplyes();
            // $('#txtResolveTime').timepicker();

            $('#txtResolveTime').blur(function () {
                var validTime = $(this).val().match(/^(0?[1-9]|1[012])(:[0-5]\d) [APap][mM]$/);
                if (!validTime) {
                    $(this).val('').css('background', '#fdd');
                } else {
                    $(this).css('background', '#fff');
                }
            });
        });

    </script>
    <script type="text/javascript">
        function chkStatus() {
            jQuery("#spnOtherEmailId,#spnEmployeeEmailID,#spnEmployee,#spnrootcause,#spnReopenReason").hide();
            jQuery("#txtotheremail,#txtEmployee,#hpEmployeeID,#txtrootcause,#txtReopenReason").val('');

            if (jQuery("#ddlStatus").val() == "3") {
                jQuery("#spnOtherEmailId,#spnEmployee,#spnEmployeeEmailID").show();
                jQuery("#txtotheremail,#txtEmployeeEmailID,#txtEmployee,#hpEmployeeID").val('');
            }
            else if (jQuery("#ddlStatus").val() == "4") {
                jQuery("#spnrootcause").show();
                jQuery("#txtrootcause").val('');

            }
            else if (jQuery("#ddlStatus").val() == "5") {
                jQuery("#spnReopenReason").show();
                jQuery("#txtReopenReason").val('');
            }

            if (jQuery("#ddlStatus").val() == "0") {
                jQuery("#spnExpectedResolveDateTime").hide();
                jQuery("#txtResolveDate").val('');
                jQuery("#txtResolveTime").val('');
            }
            else if (jQuery("#ddlStatus").val() == "4") {
                jQuery("#spnExpectedResolveDateTime").hide();
                jQuery("#txtResolveDate").val('');
                jQuery("#txtResolveTime").val('');
            }
            else {
                jQuery("#spnExpectedResolveDateTime").show();
                jQuery("#txtResolveDate").val('');
                jQuery("#txtResolveTime").val('');
            }

        }
        </script>
        <script type="text/javascript">
            jQuery("#txtEmployee")
                  .bind("keydown", function (event) {
                      if (event.keyCode === $.ui.keyCode.TAB &&
                         jQuery(this).autocomplete("instance").menu.active) {
                          event.preventDefault();
                      }

                  })
                  .autocomplete({
                      autoFocus: true,
                      source: function (request, response) {
                          jQuery.getJSON("AnswerTicket.aspx?cmd=GetEmpList", {
                              EmpName: extractLast1(request.term),
                              TicketID: jQuery('#<%=lblTicketID.ClientID%>').text()
                          }, response);
                      },
                      search: function () {
                          // custom minLength
                          var term = extractLast1(this.value);
                          if (term.length < 2) {
                              return false;
                          }
                      },
                      focus: function () {
                          // prevent value inserted on focus
                          return false;
                      },
                      select: function (event, ui) {
                          this.value = '';
                          jQuery("#<%=txtEmployee.ClientID%>").val(ui.item.label);
                          jQuery("#<%=hpEmployeeID.ClientID%>").val(ui.item.value);
                          jQuery("#<%=txtEmployeeEmailID.ClientID%>").val(ui.item.Email);
                          enableDisable(ui.item.Email);
                          return false;
                      },
                  });
                  function extractLast1(term) {
                      return term;
                  }

    </script>
    <script type="text/javascript">
        function showPrintscreen() {
            var FileName = "";
            if (jQuery('#<%=lblFileName.ClientID%>').text() == "") {
                FileName = (Math.random() + ' ').substring(2, 10) + (Math.random() + ' ').substring(2, 10);
            }
            else {
                FileName = $('#<%=lblFileName.ClientID%>').text();
            }
            jQuery('#<%=lblFileName.ClientID%>').text(FileName);
            window.open('../CallCenter/UploadPrintScreen.aspx?TicketId=' + jQuery('#<%=lblEncryptTicketID.ClientID%>').text() + '&ReplyID=' + FileName, null, 'left=150, top=100, height=700, width=910, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');
           
        }

        function showuploadbox() {
            var FileName = "";
            if (jQuery('#<%=lblFileName.ClientID%>').text() == "") {
                FileName = (Math.random() + ' ').substring(2, 10) + (Math.random() + ' ').substring(2, 10);
            }
            else {
                FileName = $('#<%=lblFileName.ClientID%>').text();
            }
            jQuery('#<%=lblFileName.ClientID%>').text(FileName);
             window.open('../CallCenter/UploadDocument.aspx?TicketId=' + jQuery('#<%=lblEncryptTicketID.ClientID%>').text() + '&ReplyID=' + FileName, null, 'left=150, top=100, height=350, width=810, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');
         }
        function showerrormsg(msg) {
            jQuery('#msgField').html('');
            jQuery('#msgField').append(msg);
            jQuery(".alert").css('background-color', 'red');
            jQuery(".alert").removeClass("in").show();
            jQuery(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
    </script>
    <script type="text/javascript">
        function SaveReply() {
            if (jQuery.trim(jQuery("#txtRply").val()) == "") {
                showerrormsg('Please Enter Reply');
                jQuery("#txtRply").focus();
                return;
            }
            if (jQuery.trim(jQuery("#ddlStatus").val()) == "0") {
                showerrormsg('Please Select Status');
                jQuery("#ddlStatus").focus();
                return;
            }
            if (jQuery.trim(jQuery("#ddlStatus").val()) == "3" && jQuery.trim(jQuery('#<%=txtEmployee.ClientID%>').val()) == "") {
                showerrormsg('Please Enter Assign Employee');
                jQuery("#txtEmployee").focus();
                return;
            }
            if (jQuery.trim(jQuery("#ddlStatus").val()) == "3" && jQuery.trim(jQuery('#<%=txtEmployeeEmailID.ClientID%>').val()) == "") {
                if (!isValidEmailAddress)
                    showerrormsg('Please Enter EmailID.!');
                jQuery("#txtEmployeeEmailID").focus();
                return;
            }
            if (jQuery.trim(jQuery("#ddlStatus").val()) == "3" && jQuery.trim(jQuery('#<%=txtEmployeeEmailID.ClientID%>').val()) != "") {
                if (!isValidEmailAddress(jQuery('#<%=txtEmployeeEmailID.ClientID%>').val())) {
                    showerrormsg('Please Enter valid EmailID.!');
                    jQuery("#txtEmployeeEmailID").focus();
                    return;
                }
            }

            if (jQuery.trim(jQuery("#ddlStatus").val()) == "3" && jQuery.trim(jQuery('#<%=txtotheremail.ClientID%>').val()) != "") {
                var valid = true;
                var emails = jQuery('#<%=txtotheremail.ClientID%>').val().split(",");
                var regex = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;

                for (var i = 0; i < emails.length; i++) {
                    if (emails[i] == "" || !regex.test(emails[i])) {
                        valid = false;
                    }
                }
                if (!valid) {
                    showerrormsg('Please Enter valid Other EmailID.!');
                    jQuery("#txtotheremail").focus();
                    return;
                }
            }



            if (jQuery.trim(jQuery("#ddlStatus").val()) == "4" && jQuery.trim(jQuery('#<%=ddlRootCause.ClientID%>').val()) == "0") {
                showerrormsg('Please Select Root Cause.');
                jQuery('#<%=ddlRootCause.ClientID%>').focus();
            return;
        }
        if (jQuery.trim(jQuery("#ddlStatus").val()) == "5" && jQuery.trim(jQuery('#<%=txtReopenReason.ClientID%>').val()) == "") {
                showerrormsg('Please Enter ReOpen Reason');
                jQuery("#txtReopenReason").focus();
                return;
            }


            jQuery('#btnSaveReply').attr('disabled', 'disabled').val('Saving...');
            var resultAnswer = AnswerTicket();
            jQuery.ajax({
                url: "AnswerTicket.aspx/saveAnswerTicket",
                data: JSON.stringify({ Ticket: resultAnswer }),
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        showerrormsg("Record Saved Successfully");
                        jQuery('#spnStatus').text(jQuery('#<%=ddlStatus.ClientID%> option:selected').text());
                    bindStatus();
                    BindReplyes();
                }
                else if (result.d == "2") {
                    showerrormsg("Please Enter Valid Time.");
                    jQuery('#<%=txtResolveTime.ClientID%>').focus();
                        jQuery('#btnSaveReply').removeAttr('disabled').val('Save');
                        return;
                    }
                    else if (result.d == "3") {
                        showerrormsg("Please Enter Valid Date.");
                        jQuery('#<%=txtResolveDate.ClientID%>').focus();
                        jQuery('#btnSaveReply').removeAttr('disabled').val('Save');
                        return;
                    }
                    else {
                        showerrormsg('Error...');
                    }
                clearRecord();
                jQuery('#btnSaveReply').removeAttr('disabled').val('Save');
            },
            error: function (xhr, status) {
                jQuery('#btnSaveReply').removeAttr('disabled').val('Save');
            }
        });
}
function AnswerTicket() {
    var dataAnswer = new Array();
    var objAnswer = new Object();
    objAnswer.Reply = jQuery('#<%=txtRply.ClientID%>').val();
        objAnswer.Status = jQuery('#<%=ddlStatus.ClientID%> option:selected').text();
        objAnswer.StatusID = jQuery('#<%=ddlStatus.ClientID%>').val();
        objAnswer.TicketID = jQuery('#<%=lblTicketID.ClientID%>').text();
        objAnswer.AttachedFileName = jQuery('#<%=lblFileName.ClientID%>').text();
        if (jQuery.trim(jQuery('#<%=txtEmployee.ClientID%>').val()) != "" && jQuery('#<%=hpEmployeeID.ClientID%>').val() != "")
            objAnswer.EmpID = jQuery('#<%=hpEmployeeID.ClientID%>').val();
    else
        objAnswer.EmpID = 0;

    if (jQuery.trim(jQuery('#<%=ddlRootCause.ClientID%>').val()) != "0")
            objAnswer.Rootcause = jQuery('#<%=ddlRootCause.ClientID%>').val();
            else
                objAnswer.Rootcause = 0;

            if (jQuery.trim(jQuery("#ddlStatus").val()) == "5") {
                objAnswer.ReopenReason = jQuery.trim(jQuery('#<%=txtReopenReason.ClientID%>').val());
            }
            else {
                objAnswer.ReopenReason = "";
            }

            if (jQuery("#<%=txtResolveDate.ClientID %>").val() != "") {
            objAnswer.resolveDateTime = jQuery("#<%=txtResolveDate.ClientID %>").val() + " " + jQuery("#<%=txtResolveTime.ClientID %>").val();
            }
            else {
                objAnswer.resolveDateTime = "";
            }

        // Email Code Start
            if (jQuery.trim(jQuery('#<%=txtEmployeeEmailID.ClientID%>').val()) != "")
            objAnswer.EmailID = jQuery('#<%=txtEmployeeEmailID.ClientID%>').val();
            else
                objAnswer.EmailID = "";

            if (jQuery.trim(jQuery('#<%=txtotheremail.ClientID%>').val()) != "")
            objAnswer.OtherEmailID = jQuery('#<%=txtotheremail.ClientID%>').val();
            else
                objAnswer.OtherEmailID = "";

            objAnswer.IsEmail = $('#hdnIsEmailID').text();
            objAnswer.empCode = $('#spnEmpID').text();
            objAnswer.empName = $('#spnEmpName').text();
            objAnswer.empEmail = $('#spnEmail').text();
            objAnswer.empMobile = $('#spnMobile').text();
            objAnswer.empGroup = $('#spnGroup').text();
            objAnswer.empClientCode = $('#spnClientCode').text();
            objAnswer.empSubject = $('#spnSubject').text();
            objAnswer.CreatedDate = $('#spnDate').text();
            objAnswer.Message = $('#spnMessage').text();

        // Email Code End

            objAnswer.Subject = jQuery('#spnSubject').text();


            dataAnswer.push(objAnswer);
            return dataAnswer;
        }
        function clearRecord() {
            jQuery('#ddlQueries,#ddlStatus,#ddlRootCause').prop('selectedIndex', 0);
            jQuery('#ddlQueries').trigger('chosen:updated');
            jQuery("#spnOtherEmailId,#spnEmployeeEmailID,#spnEmployee,#spnrootcause,#spnReopenReason").hide();
            jQuery("#txtotheremail,#txtRply,#txtEmployee,#hpEmployeeID,#txtrootcause,#txtReopenReason").val('');
            jQuery("#<%=txtResolveDate.ClientID %>").val('');
            jQuery("#<%=txtResolveTime.ClientID %>").val('');
            $('#spnExpectedResolveDateTime').hide();
            jQuery('#<%=lblFileName.ClientID%>').text('');
        }
        function bindDetail() {
            jQuery("#<%=txtRply.ClientID %>").val('');
            if ($("#<%=ddlQueries.ClientID %>").val() != "0") {
                jQuery.ajax({
                    url: "AnswerTicket.aspx/ResponseDetail",
                    data: '{ ResponseID: "' + jQuery("#<%=ddlQueries.ClientID %>").val() + '"}',
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        jQuery("#<%=txtRply.ClientID %>").val(result.d);
                    },
                    error: function (xhr, status) {
                    }
                });
                }
                else {
                }
            }
    </script>

    <script type="text/javascript">
        jQuery(function () {
            getHeader();
            bindRootCause();
        });
        function getHeader() {
            jQuery.ajax({
                url: "AnswerTicket.aspx/getHeader",
                data: '{ TicketId: "' + jQuery("#<%=lblTicketID.ClientID %>").text() + '"}',
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {

                    var data = $.parseJSON(result.d);
                    if (data != null) {
                        jQuery("#spnEmpID").text(data[0].House_No);
                        jQuery("#spnEmpName").text(data[0].EmpName);
                        jQuery("#spnStatus").text(data[0].Status);

                        jQuery("#spnClientCode").text(data[0].Panel_Code);
                        jQuery("#spnDate").text(data[0].dtAdd);
                        jQuery("#spnSubject").text(data[0].Subject);
                        jQuery("#spnMessage").text(data[0].Message);
                        jQuery("#lblCategoryID").text(data[0].CategoryID);
                        jQuery("#lblSubCategoryID").text(data[0].SubcategoryID);
                        jQuery("#lblReoprnRight").text(data[0].ReopenTicket);

                        jQuery("#spnEmail").text(data[0].Email);
                        jQuery("#spnMobile").text(data[0].Mobile);
                        jQuery("#spnGroup").text(data[0].GroupName);
                        if ($.trim(data[0].VialId) == "")
                            jQuery("#spnVialID,#tdVialID").hide();
                        else
                            jQuery("#spnVialID").text(data[0].VialId);
                        if ($.trim(data[0].RegNo) == "")
                            jQuery("#spnRegNo,#tdRegNo").hide();
                        else
                            jQuery("#spnRegNo").text(data[0].RegNo);
                        if ($.trim(data[0].DepartmentName) == "")
                            jQuery("#spnDepartment,#tdDepartment").hide();
                        else
                            jQuery("#spnDepartment").text(data[0].DepartmentName);

                        BindQueries();
                        bindStatus();
                    }
                },
                error: function (xhr, status) {
                }
            });
        }
        function BindQueries() {
            jQuery.ajax({
                url: "AnswerTicket.aspx/BindQueries",
                data: '{ CategoryID: "' + jQuery("#<%=lblCategoryID.ClientID %>").text() + '", SubCategoryID: "' + jQuery("#<%=lblSubCategoryID.ClientID %>").text() + '"}',
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result != null) {
                        var ItemData = jQuery.parseJSON(result.d);
                        if (ItemData.length == 0) {
                            jQuery("#<%=ddlQueries.ClientID %>").append($("<option></option>").val("0").html("---No Data Found---"));
                        }
                        else {
                            jQuery("#<%=ddlQueries.ClientID %>").append($("<option></option>").val("0").html("---Select---"));
                            for (i = 0; i < ItemData.length; i++) {
                                jQuery("#<%=ddlQueries.ClientID %>").append($("<option></option>").val(ItemData[i].Id).html(ItemData[i].Subject));
                            }
                        }
                        jQuery("#<%=ddlQueries.ClientID %>").trigger('chosen:updated');
                    }
                },
                error: function (xhr, status) {
                }
            });
        }
        function bindStatus() {
            jQuery("#ddlStatus option").remove();
            jQuery.ajax({
                url: "AnswerTicket.aspx/bindStatus",
                data: '{ }',
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    if (result != null) {
                        var ItemData = jQuery.parseJSON(result.d);
                        jQuery("#<%=ddlStatus.ClientID %>").append($("<option></option>").val("0").html("Select"));
                        for (i = 0; i < ItemData.length; i++) {
                            jQuery("#<%=ddlStatus.ClientID %>").append($("<option></option>").val(ItemData[i].ID).html(ItemData[i].Status));
                        }
                        statusCon();
                    }
                },
                error: function (xhr, status) {
                }
            });
        }
        function statusCon() {
            jQuery("#ddlStatus option[value='1']").remove();

            if (jQuery("#spnStatus").text() == "Resolved") {
                jQuery("#ddlStatus option[value='2']").remove(); //Initial Reply
                jQuery("#ddlStatus option[value='3']").remove(); //Assign
                jQuery("#ddlStatus option[value='4']").remove(); //Resolved
                jQuery("#ddlStatus option[value='6']").remove();//Reply
                jQuery("#ddlStatus option[value='7']").remove();//Acknowledge  
                if (jQuery("#lblReoprnRight").text() == "0") {
                    jQuery("#ddlStatus option[value='5']").remove();
                }
            }
            else if (jQuery("#spnStatus").text() == "ReOpen") {
                jQuery("#ddlStatus option[value='5']").remove();//ReOpen
            }
            else if (jQuery("#spnStatus").text() == "New") {
                jQuery("#ddlStatus option[value='5']").remove();//ReOpen
            }
            else if (jQuery("#spnStatus").text() == "Initial Reply") {
                jQuery("#ddlStatus option[value='5']").remove();//ReOpen
            }
            else if (jQuery("#spnStatus").text() == "Assign") {
                jQuery("#ddlStatus option[value='3']").remove();//ReOpen
                jQuery("#ddlStatus option[value='5']").remove();//ReOpen
            }
            else if (jQuery("#spnStatus").text() == "Reply") {
                // jQuery("#ddlStatus option[value='6']").remove();//Reply 
                jQuery("#ddlStatus option[value='5']").remove();//ReOpen
            }
            else if (jQuery("#spnStatus").text() == "Acknowledge") {
                //jQuery("#ddlStatus option[value='7']").remove();//Acknowledge 
                jQuery("#ddlStatus option[value='5']").remove();//ReOpen
            }
        }


    </script>

    <script type="text/javascript">
        function BindReplyes() {

            jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
            jQuery.ajax({
                url: "AnswerTicket.aspx/GetReply",
                data: '{ TicketId: "' + jQuery("#<%=lblTicketID.ClientID %>").text() + '"}',
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    ReplyData = $.parseJSON(result.d);
                    if (ReplyData.length == 0) {
                        jQuery('#divReplyOutput').empty();
                        return;
                    }

                    var output = jQuery('#tb_Reply').parseTemplate(ReplyData);
                    jQuery('#divReplyOutput').html(output);
                    jQuery.unblockUI();
                },
                error: function (xhr, status) {
                    jQuery.unblockUI();

                }
            });


        }
    </script>
     <script type="text/javascript">
         $(document).on("mouseenter", "a.im", function (e) {
             var url = $(this).attr("url");
             console.log(url);
             var ext = url.substring(url.lastIndexOf(".") + 1);
             if (ext != "doc" && ext != "docx") {
                 openpopup(url)
             }
         });
         function openpopup(FilePath) {
             window.open('image.aspx?FilePath=' + FilePath, null, 'left=150, top=100, height=350, width=810, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');
         }
         function showerrormsg(msg) {
             jQuery('#msgField').html('');
             jQuery('#msgField').append(msg);
             jQuery(".alert").css('background-color', 'red');
             jQuery(".alert").removeClass("in").show();
             jQuery(".alert").delay(1500).addClass("in").fadeOut(1000);
         }
        </script>
     <script type="text/javascript">
         function OpenDesignationWindow() {
             $find('Designation').show();
             $('#txtdesignation').focus();
         }
         function CloseDesignationWindow() {
             $find('Designation').hide();
             $('#txtdesignation').val('');
             $('#lblMsgDesignation').text('');
         }
         function SaveDesignation() {
             if ($.trim($('#txtdesignation').val()) == "") {
                 $('#lblMsgDesignation').text("Please Enter Root Couse");
                 $('#txtdesignation').focus();
                 return;
             }
             $('#btnsaveDesignation').attr('disabled', 'disabled').val('Submitting...');
             jQuery.ajax({
                 url: "AnswerTicket.aspx/SaveRootCause",
                 data: JSON.stringify({ DesignationName: $.trim($('#txtdesignation').val()) }),
                 type: "POST", // data has to be Posted    	        
                 contentType: "application/json; charset=utf-8",
                 timeout: 120000,
                 dataType: "json",
                 success: function (result) {
                     if (result.d == "2") {
                         $('#lblMsgDesignation').text("Designation Name Already Exist");
                     }
                     else if (result.d == "0") {
                         alert('Error...');
                     }
                     else {
                         var data = $.parseJSON(result.d)
                         $("#<%=ddlRootCause.ClientID%>").find('option:selected').removeAttr("selected");
                         $("#<%=ddlRootCause.ClientID%>").append('<option value="' + data.DesignationID + '" selected="selected">' + data.DesignationName + '</option>');
                         CloseDesignationWindow();
                     }
                     $('#btnsaveDesignation').removeAttr('disabled').val('Save');
                 },
                 error: function (xhr, status) {
                 }
             });
     }

     function bindRootCause() {
         jQuery("#ddlRoootCause option").remove();
         jQuery.ajax({
             url: "AnswerTicket.aspx/bindRootCause",
             data: '{ }',
             type: "POST", // data has to be Posted    	        
             contentType: "application/json; charset=utf-8",
             timeout: 120000,
             async: false,
             dataType: "json",
             success: function (result) {
                 if (result != null) {
                     var ItemData = jQuery.parseJSON(result.d);
                     jQuery("#<%=ddlRootCause.ClientID %>").append($("<option></option>").val("0").html("Select"));
                     for (i = 0; i < ItemData.length; i++) {
                         jQuery("#<%=ddlRootCause.ClientID %>").append($("<option></option>").val(ItemData[i].ID).html(ItemData[i].RootCause));
                     }

                 }
             },
             error: function (xhr, status) {
             }
         });
     }
    </script>
    <script type="text/javascript">
        function enableDisable(val) {
            console.log(val);
            if ($.trim(val) == "") {
                $('#txtEmployeeEmailID').prop("disabled", false);
                $('#hdnIsEmailID').val("1");
            }
            else {
                $('#txtEmployeeEmailID').prop("disabled", true);
                ('#hdnIsEmailID').val("0");
            }

        }

        function CheckMail() {
        }

        function isValidEmailAddress(emailAddress) {
            var pattern = new RegExp(/^[+a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/i);

            return pattern.test(emailAddress);
        };
    </script>
</asp:Content>

