<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" ClientIDMode="Static" EnableEventValidation="false" ValidateRequest="false" CodeFile="NewTicket.aspx.cs" Inherits="Design_CallCenter_NewTicket" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <script src="../../Scripts/datatables.min.js"></script> 
     <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/jquery.dataTables.min.css">
    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <style type="text/css">
        .alert {
            display: none;
            height: 40px;
            width: 380px;
            max-width: 50%;
            min-width: 320px;
            font-weight: bold;
            color: white;
            background-color: #e04747;
            float: right;
            top: 2em;
            padding: 10px;
            right: 1em;
            border-radius: 5px;
            text-align: center;
        }

        .spncolor {
            color: black;
        }

        #queryListHead td, #queryList th {
            padding: 5px;
            background-color: silver;
        }

        #queryListHead tr:nth-child(even) {
            background-color: #C0C0C0;
        }

        #queryListHead tr:nth-child(even) {
            background-color: #d8d0f5;
        }

        /* feed Back Css Start */
        .modal-popup {
            display: none; /* Hidden by default */
            position: fixed; /* Stay in place */
            z-index: 1; /* Sit on top */
            padding-top: 15%; /* Location of the box */
            left: 0;
            top: 0;
            width: 100%; /* Full width */
            height: 100%; /* Full height */
            overflow: auto; /* Enable scroll if needed */
            background-color: rgb(0,0,0); /* Fallback color */
            background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
        }

        .modal-popup-content {
            background-color: #fefefe;
            margin: auto;
            padding: 20px;
            border: 1px solid #888;
            width: 357px;
            padding-bottom: 10px;
        }

        .modal-popup-header {
            position: relative;
            margin-top: 0px;
            margin-right: -22px;
        }

        .modal-popup-body {
            height: 32px;
            width: 100%;
            border-bottom: 1px solid #ccc;
            margin-top: 15px;
        }

        .modal-popup-footer {
            text-align: right;
            margin-top: 10px;
            text-align: right;
            margin-right: -15px;
        }

        .popup-close {
            color: #aaaaaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            position: absolute;
            right: 0;
            top: -29px;
        }

            .popup-close:hover,
            .popup-close:focus {
                color: #000;
                text-decoration: none;
                cursor: pointer;
            }


        .popup-botton {
            -moz-box-shadow: inset 0px 1px 0px 0px #ffffff;
            -webkit-box-shadow: inset 0px 1px 0px 0px #ffffff;
            box-shadow: inset 0px 1px 0px 0px #ffffff;
            background: -webkit-gradient(linear, left top, left bottom, color-stop(0.05, #f9f9f9), color-stop(1, #e9e9e9));
            background: -moz-linear-gradient(top, #f9f9f9 5%, #e9e9e9 100%);
            background: -webkit-linear-gradient(top, #f9f9f9 5%, #e9e9e9 100%);
            background: -o-linear-gradient(top, #f9f9f9 5%, #e9e9e9 100%);
            background: -ms-linear-gradient(top, #f9f9f9 5%, #e9e9e9 100%);
            background: linear-gradient(to bottom, #f9f9f9 5%, #e9e9e9 100%);
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#f9f9f9', endColorstr='#e9e9e9',GradientType=0);
            background-color: #f9f9f9;
            -moz-border-radius: 6px;
            -webkit-border-radius: 6px;
            border-radius: 6px;
            border: 1px solid #dcdcdc;
            display: inline-block;
            cursor: pointer;
            color: #666666;
            font-family: Arial;
            font-size: 15px;
            font-weight: bold;
            padding: 6px 12px;
            text-decoration: none;
            text-shadow: 0px 1px 0px #ffffff;
        }

            .popup-botton:hover {
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0.05, #e9e9e9), color-stop(1, #f9f9f9));
                background: -moz-linear-gradient(top, #e9e9e9 5%, #f9f9f9 100%);
                background: -webkit-linear-gradient(top, #e9e9e9 5%, #f9f9f9 100%);
                background: -o-linear-gradient(top, #e9e9e9 5%, #f9f9f9 100%);
                background: -ms-linear-gradient(top, #e9e9e9 5%, #f9f9f9 100%);
                background: linear-gradient(to bottom, #e9e9e9 5%, #f9f9f9 100%);
                filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#e9e9e9', endColorstr='#f9f9f9',GradientType=0);
                background-color: #e9e9e9;
            }
        /* feed Back Css End */
    </style>


    <div id="NewticketModal" class="modal-popup">
        <!-- Modal content -->
        <div class="modal-popup-content">
            <div class="modal-popup-header">
                <span id="spnTicketStatus" style=" font:bold"></span> <span class="popup-close">&times;</span>
            </div>
            <div class="modal-popup-body">
                <b>Ticket No. : <span id="viewticketid"></span></b>
            </div>
            <div class="modal-popup-footer">
                <input id="btnclose" class="btnFeed" type="button" value="OK" />&nbsp; 
                
            </div>
        </div>
    </div>
    <div class="alert fade" style="position:absolute;left:30%;border-radius:15px;z-index:11111;top:20%;">
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>

    <div id="Pbody_box_inventory" style="width: 1300px;">
        <Ajax:ScriptManager ID="sc" runat="server" EnablePageMethods="true"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="width: 1296px; text-align: center;">

            <b>New Support Query</b>
            <asp:Label ID="lblTicketID" runat="server" ClientIDMode="Static" style="display:none"></asp:Label>
            
        </div>

        <div class="POuter_Box_Inventory" style="width: 1296px">
            <div class="Purchaseheader">
                Submit New Issue
            </div>
            <div class="content" style="text-align: center;">
               
                
               
              
                
                

                <table style="width: 100%; border-collapse: collapse">
                    <tr>
                        <th style="width: 30%; text-align: right">Group :&nbsp;</th>
                        <td style="text-align: left">
                            <asp:DropDownList ID="ddlGroup" CssClass="chosen-select" runat="server" Width="455px" onchange="bindCategory()"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <th style="width: 30%; text-align: right">Category :&nbsp;</th>
                        <td style="text-align: left">
                            <asp:DropDownList ID="ddlCategory" CssClass="chosen-select" runat="server" Width="455px" onchange="bindSubcategory()"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <th style="width: 30%; text-align: right">Sub Category :&nbsp;</th>
                        <td style="text-align: left">
                            <asp:DropDownList ID="ddlSubCategory" CssClass="chosen-select" runat="server" Width="455px" onchange="ChangeSubcategory();"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <th style="width: 30%; text-align: right">Predefined Queries :&nbsp;</th>
                        <td style="text-align: left">
                            <asp:DropDownList ID="ddlQueries" runat="server" Width="455px" CssClass="chosen-select"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <th style="width: 30%; text-align: right">Subject :&nbsp;</th>
                        <td style="text-align: left">
                            <asp:TextBox ID="txtSub" runat="server" Width="450px" MaxLength="100"></asp:TextBox>
                        </td>
                    </tr>

                    <tr>
                        <th style="width: 30%; text-align: right; vertical-align: top">Detail :&nbsp;</th>
                        <td style="text-align: left">
                            <asp:TextBox ID="txtDetail" runat="server" TextMode="MultiLine" Rows="6" Width="449px" Style="max-width: 449px" ClientIDMode="Static"></asp:TextBox>
                            Number of Characters Left:
                        <label id="lblremaingCharacters" style="background-color: #E2EEF1; color: Red; font-weight: bold;">
                        </label>

                        </td>
                    </tr>
                    <tr id="ShowBarcodeNumber" style="display: none;">
                        <th style="width: 30%; text-align: right">SIN No. :&nbsp;</th>
                        <td style="text-align: left">
                            <asp:TextBox ID="txtVialId" runat="server" Width="450px"></asp:TextBox></td>
                    </tr>
                    <tr id="ShowPatientID" style="display: none;">
                        <th style="width: 30%; text-align: right">UHID No. :&nbsp;</th>
                        <td style="text-align: left; margin-left: 40px;">
                            <asp:TextBox ID="txtRegNo" runat="server" Width="450px"></asp:TextBox></td>
                    </tr>
                    <tr id="ShowVisitNo" style="display: none;">
                        <th style="width: 30%; text-align: right">Visit No. :&nbsp;</th>
                        <td style="text-align: left; margin-left: 40px;">
                            <asp:TextBox ID="txtVisitNo" runat="server" Width="450px"></asp:TextBox></td>
                    </tr>

                    <tr id="ShowDepartment" style="display: none;">
                        <th style="width: 30%; text-align: right">Department :&nbsp;</th>
                        <td style="text-align: left; margin-left: 40px;">
                            <asp:DropDownList ID="ddlDepartment" runat="server" Width="455px" CssClass="chosen-select" onchange="bindItem()"></asp:DropDownList>
                        </td>
                    </tr>
                     <tr id="ShowInvestigationID" style="display: none;">
                        <th style="width: 30%; text-align: right">Test Name :&nbsp;</th>
                        <td style="text-align: left; margin-left: 40px;">
                            <asp:DropDownList ID="ddlInvestigation" runat="server" Width="455px" CssClass="chosen-select"></asp:DropDownList>

                        </td>
                    </tr>


                    <tr id="trTagEmployee" style="display: none;">
                        <th style="width: 30%; text-align: right">TagEmployee :&nbsp;</th>
                        <td style="text-align: left; margin-left: 40px;">
                            <asp:TextBox ID="txtEmployeeName" runat="server" Width="230px" ClientIDMode="Static" />
                            <input type="hidden" id="hdEmployeeID" />
                        </td>
                    </tr>
                    <tr id="trResolveDateTime" style="display: none;">
                        <th style="width: 30%; text-align: right">Resolve DateTime :&nbsp;</th>
                        <td style="text-align: left; margin-left: 40px;">
                            <asp:TextBox ID="txtResolveDate" runat="server" Width="90px"></asp:TextBox>
                            <cc1:CalendarExtender ID="calResolveDate" runat="server" Format="dd-MMM-yyyy" TargetControlID="txtResolveDate" />
                            <asp:TextBox ID="txtResolveTime" runat="server" Width="66px"></asp:TextBox>
                            <cc1:MaskedEditExtender runat="server" ID="mee_txtFromTime" Mask="99:99:99" TargetControlID="txtResolveTime"
                                AcceptAMPM="false" AcceptNegative="None" MaskType="Time">
                            </cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator runat="server" ID="mev_txtFromTime"
                                ControlExtender="mee_txtFromTime"
                                ControlToValidate="txtResolveTime"
                                InvalidValueMessage="*">
                            </cc1:MaskedEditValidator>

                        </td>
                    </tr>
                    <tr>
                        <th style="width: 30%; text-align: right">Attachment :&nbsp;</th>
                        <td style="text-align: left; margin-left: 40px;">
                            <asp:Label ID="lblFileName" runat="server" Style="display: none;"></asp:Label>
                            <span style="font-weight: bold;"><a style="color: blue;" href="javascript:void(0)" onclick="showuploadbox()">Upload Attachment</a></span>
                            <%if (Util.GetString(Request.QueryString["FileName"]) != string.Empty)
                              { %>
                            &nbsp; <span style="font-weight: bold; color: red;" id="spnScreen">Screen shot Attached</span>
                            <%} %>  &nbsp; 
                            <span style="font-weight: bold;"><a style="color: blue;" href="javascript:void(0)" onclick="showPrintscreen()">Upload Print Screen Attachment</a></span>
                        </td>
                    </tr>
                </table>
            </div>
        </div>

        <div class="POuter_Box_Inventory" style="width: 1296px; text-align: center;">
            <input type="button" id="btnSave" value="Save" onclick="Save()" class="searchbutton" />
           &nbsp;&nbsp;
            <input type="button" id="btnCancel" value="Cancel" onclick="Cancel()" class="searchbutton" />


        </div>
         <div class="POuter_Box_Inventory" style="width: 1296px; text-align: center;">
             <div class="Purchaseheader">
                Search Your Old Issue
            </div>
             <table style="width: 70%; margin: 0 auto; margin-top: 10px;">
                    <tr>
                         <td style="border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; cursor: pointer; width: 25px; border-bottom: black thin solid; background-color: #768aa3;"
                            onclick="Search('1');">&nbsp; &nbsp;&nbsp;</td>
                        <td style="text-align: left; font-size: 11pt;">New</td>
                        <td style="border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; cursor: pointer; width: 25px; border-bottom: black thin solid; background-color: #b3b9c0;"
                            onclick="Search('2');">&nbsp; &nbsp;&nbsp;</td>
                        <td style="text-align: left; font-size: 11pt">Initial Reply</td>
                        <td style="border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; cursor: pointer; width: 25px; border-bottom: black thin solid; background-color: #00cccc"
                            onclick="Search('3');">&nbsp; &nbsp;&nbsp;</td>
                        <td style="text-align: left; font-size: 11pt">Assign/Forward</td>
                        <td style="border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; cursor: pointer; width: 25px; border-bottom: black thin solid; background-color: #6993ca;"
                            onclick="Search('6');">&nbsp; &nbsp;&nbsp;</td>
                        <td style="text-align: left; font-size: 11pt;">Reply</td>
                        
                        <td style="border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; cursor: pointer; width: 25px; border-bottom: black thin solid; background-color: #ccffcc;"
                            onclick="Search('5');">&nbsp; &nbsp;&nbsp;</td>
                        <td style="text-align: left; font-size: 11pt;">ReOpen</td>
                        <td style="border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; cursor: pointer; width: 25px; border-bottom: black thin solid; background-color: #ffd2d2;"
                            onclick="Search('7');">&nbsp; &nbsp;&nbsp;</td>
                        <td style="text-align: left; font-size: 11pt;">Acknowledge</td>

                       <td style="border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; cursor: pointer; width: 25px; border-bottom: black thin solid; background-color: #ff7f24;"
                            onclick="Search('4');">&nbsp; &nbsp;&nbsp;</td>
                        <td style="text-align: left; font-size: 11pt;">Resolved</td>

                    </tr>
                </table>
             <table style="width: 100%; border-collapse: collapse">
                    <tr>
                        <td style="width:20%;text-align:right">
                           <b> From Date :&nbsp;</b>
                        </td>
                        <td style="text-align:left;width:16%;">
                             <asp:TextBox ID="txtFromDate" runat="server" Width="110px" ClientIDMode="Static" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </td>
                        <td style="width:12%;text-align:right">
                             <b>To Date :&nbsp;</b>
                        </td>
                        <td style="text-align:left;width:16%;">
                            <asp:TextBox ID="txtToDate" runat="server" Width="110px" ClientIDMode="Static" />
                        <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </td>
                        <td style="width:12%;text-align:right">
                            <b>Status :&nbsp;</b>
                            </td>
                         <td style="text-align:left;width:16%;">
                        <asp:DropDownList ID="ddlStatus" runat="server" Width="140px"></asp:DropDownList>    
                        </td>
                        <td style="text-align:left;width:20%;">
                             <button type="button" id="btnSearch" onclick="Search('0')" class="searchbutton">Search</button>
                        </td>
                        </tr>

                 </table>

              <div id="divOldTicket" style="text-align:left;" >
              <table id="gridtable" class="table stripe cell-border">
                    <thead>
                        <tr style="background:#88c3ff;">   
                            <th style="width: 62px; text-align: center"></th>
                            <th style="width: 120px; text-align: center">Group</th>
                            <th style="width: 120px; text-align: center">Category</th>
                            <th style="width: 120px; text-align: center">SubCategory</th>
                            <th style="width: 120px; text-align: center">Subject</th> 
                            <th style="width: 80px; text-align: center">Raised Date</th>
                               <th style="width: 60px; text-align: center">Edit</th>      
                        </tr>
                    </thead>
                </table>
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
                 
             </div>
    </div>

    <script type="text/javascript">
        function showuploadbox() {
            var filename = "";
            if (jQuery('#<%=lblFileName.ClientID%>').text() == "") {
                filename = (Math.random() + ' ').substring(2, 10) + (Math.random() + ' ').substring(2, 10);
            }
            else {
                filename = $('#<%=lblFileName.ClientID%>').text();
            }
            jQuery('#<%=lblFileName.ClientID%>').text(filename);
            if (jQuery("#lblTicketID").text() == "")
                window.open('UploadDocument.aspx?ReplyID=' + filename, null, 'left=150, top=100, height=350, width=810, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');
            else
                PageMethods.encryptTicketID(jQuery("#lblTicketID").text(), onSucessEncryptTicketID, onfailureEncryptTicketID);




        }
        function onSucessEncryptTicketID(result) {
            window.open('UploadDocument.aspx?TicketID=' + result, null, 'left=150, top=100, height=350, width=810, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');


        }
        function onfailureEncryptTicketID(result) {


        }
    </script>

       <script type="text/javascript">
           function showPrintscreen() {
               var filename = "";
               if (jQuery('#<%=lblFileName.ClientID%>').text() == "") {
                filename = (Math.random() + ' ').substring(2, 10) + (Math.random() + ' ').substring(2, 10);
            }
            else {
                filename = $('#<%=lblFileName.ClientID%>').text();
            }
            jQuery('#<%=lblFileName.ClientID%>').text(filename);
            if (jQuery("#lblTicketID").text() == "")
                window.open('UploadPrintScreen.aspx?ReplyID=' + filename, null, 'left=150, top=100, height=700, width=910, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');
            else
                PageMethods.encryptTicketID(jQuery("#lblTicketID").text(), onSucessPrtSrcEncryptTicketID, onfailurePrtSrcEncryptTicketID);




        }
           function onSucessPrtSrcEncryptTicketID(result) {
               window.open('UploadPrintScreen.aspx?TicketID=' + result, null, 'left=150, top=100, height=700, width=910, status=no, resizable= no, scrollbars= yes, toolbar= no,location= no, menubar= no');


        }
           function onfailurePrtSrcEncryptTicketID(result) {


        }
    </script>

    <script type="text/javascript">
        function bindSubcategory() {
            jQuery("#<%=ddlSubCategory.ClientID %> option").remove();
            jQuery("#<%=ddlQueries.ClientID %> option").remove();
            jQuery("#<%=ddlQueries.ClientID %>").trigger('chosen:updated');
            jQuery("#txtSub,#txtDetail,#txtEmployeeName,#hdEmployeeID,#txtVialId,#txtRegNo").val('');

            jQuery("#trTagEmployee,#trResolveDateTime,#ShowBarcodeNumber,#ShowPatientID,#ShowInvestigationID,#ShowVisitNo,#ShowDepartment").hide();
            jQuery("#ddlInvestigation").prop('selectedIndex', 0);
            jQuery("#ddlInvestigation").trigger('chosen:updated');

            jQuery("#ddlDepartment").prop('selectedIndex', 0);
            jQuery("#ddlDepartment").trigger('chosen:updated');


            if ($("#<%=ddlCategory.ClientID %>").val() != 0) {
                $.ajax({
                    url: "NewTicket.aspx/bindSubCategory",
                    data: '{ CategoryID: "' + $("#<%=ddlCategory.ClientID %>").val() + '"}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        var ItemData = jQuery.parseJSON(result.d);
                        if (ItemData.length == 0) {
                            jQuery("#<%=ddlSubCategory.ClientID %>").append($("<option></option>").val("0").html("---No Data Found---"));
                        }
                        else {
                            jQuery("#<%=ddlSubCategory.ClientID %>").append($("<option></option>").val("0").html("---Select---"));
                            for (i = 0; i < ItemData.length; i++) {
                                jQuery("#<%=ddlSubCategory.ClientID %>").append($("<option></option>").val(ItemData[i].ID).html(ItemData[i].SubCategoryName));
                            }
                        }
                        jQuery("#<%=ddlSubCategory.ClientID %>").trigger('chosen:updated');


                        PredefinedQueries();
                    },
                    error: function (xhr, status) {

                    }
                });
            }
        }

        function getTatDetail() {

        }

        function ChangeSubcategory() {
            if (jQuery("#<%=ddlSubCategory.ClientID %>").val().split('#')[1] == "1") {
                jQuery('#ShowBarcodeNumber').show();
            }
            else {
                jQuery('#ShowBarcodeNumber').hide();
            }
            if (jQuery("#<%=ddlSubCategory.ClientID %>").val().split('#')[2] == "1") {
                jQuery('#ShowInvestigationID').show();
                jQuery('.chosen-container').attr("style", "width: 455px;");
            }
            else {
                jQuery('#ShowInvestigationID').hide();
            }
            if (jQuery("#<%=ddlSubCategory.ClientID %>").val().split('#')[3] == "1") {
                jQuery('#ShowPatientID').show();
            }
            else {
                jQuery('#ShowPatientID').hide();
            }
            if (jQuery("#<%=ddlSubCategory.ClientID %>").val().split('#')[4] == "0") {
                jQuery("#trResolveDateTime").show();
            }
            else {
                jQuery("#trResolveDateTime").hide();
            }
            if (jQuery("#<%=ddlSubCategory.ClientID %>").val().split('#')[5] == "0" && jQuery("#<%=ddlSubCategory.ClientID %>").val().split('#')[13] == "0") {
                jQuery("#trTagEmployee").show();
            }
            else {
                jQuery("#trTagEmployee").hide();

            }
            if (jQuery("#<%=ddlSubCategory.ClientID %>").val().split('#')[6] == "1") {
                jQuery('#ShowVisitNo').show();
            }
            else {
                jQuery('#ShowVisitNo').hide();
            }
            if (jQuery("#<%=ddlSubCategory.ClientID %>").val().split('#')[7] == "1") {
                jQuery('#ShowDepartment').show();
                bindDepartment();
            }
            else {
                jQuery('#ShowDepartment').hide();
            }
            jQuery("#txtEmployeeName,#hdEmployeeID").val('');
            PredefinedQueries();
        }
    </script>
    <script type="text/javascript">
        jQuery(function () {
            GetCategoryName();
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


            jQuery("#<%=ddlQueries.ClientID%>").chosen().change(function () {

                if (jQuery('#<%=ddlQueries.ClientID%> option:selected').val() != "0") {
                    jQuery.ajax({
                        type: "POST",
                        url: "NewTicket.aspx/GetInquiryDescription",
                        data: JSON.stringify({ QueryId: jQuery('#<%=ddlQueries.ClientID%>').val() }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (data) {
                            if (data.d != "") {
                                var Result = jQuery.parseJSON(data.d);
                                jQuery('#<%=txtSub.ClientID%>,#<%=txtDetail.ClientID%>').val('');

                                if (data != "") {
                                    jQuery('#<%=txtSub.ClientID%>').val(jQuery('#<%=ddlQueries.ClientID%> option:selected').text());
                                    jQuery('#<%=txtDetail.ClientID%>').val(Result[0].Detail);
                                    jQuery("#lblremaingCharacters").html(MaxLength - ($("#<%=txtDetail.ClientID %>").val().length));
                                }
                            }
                        },
                        error: function (result) {
                        }
                    });
                }
                else {
                    jQuery('#<%=txtSub.ClientID%>,#<%=txtDetail.ClientID%>').val('');
                }
            });

        });
        function GetCategoryName() {
            jQuery.ajax({
                url: "NewTicket.aspx/GetCategoryName",
                data: '',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    var categoryname = jQuery.parseJSON(result.d);
                    jQuery('#ContentPlaceHolder1_CategoryName').val('');
                    jQuery('#ContentPlaceHolder1_CategoryName').append('<option value="">---select---</option>');
                    for (var i = 0; i <= categoryname.length - 1; i++) {
                        jQuery('#ContentPlaceHolder1_CategoryName').append('<option value="' + categoryname[i].ID + '">' + categoryname[i].CategoryName + '</option>');
                    }
                },
                error: function (xhr, status) {
                    alert('Error!!!');
                }
            });
        }
    </script>
    <script type="text/javascript">
        function Save() {

            if (IsValid() == "1") {
                return;
            }
            else {
                jQuery('#btnSave').attr('disabled', 'disabled').val('Saving...');

                var obj = new Object();
                obj.GroupID = jQuery("#<%=ddlGroup.ClientID %>").val();
                obj.CatrgoryID = jQuery("#<%=ddlCategory.ClientID %>").val();
                obj.SubCatrgoryID = jQuery("#<%=ddlSubCategory.ClientID %>").val().split('#')[0];
                obj.QueryID = jQuery("#<%=ddlQueries.ClientID %>").val();
                obj.Subject = jQuery.trim(jQuery("#<%=txtSub.ClientID %>").val());
                obj.Details = jQuery.trim(jQuery("#<%=txtDetail.ClientID %>").val());
                obj.BarcodeNumber = jQuery.trim(jQuery("#<%=txtVialId.ClientID %>").val());
                obj.InvestigationID = jQuery("#<%=ddlInvestigation.ClientID %>").val();
                obj.PatientID = jQuery.trim(jQuery("#<%=txtRegNo.ClientID %>").val());
                obj.IsShowBarcodeNumber = jQuery("#<%=ddlSubCategory.ClientID %>").val().split('#')[1];
                obj.IsShowSnvestigationID = jQuery("#<%=ddlSubCategory.ClientID %>").val().split('#')[2];
                obj.IsShowPatientID = jQuery("#<%=ddlSubCategory.ClientID %>").val().split('#')[3];
                obj.IsShowVisitNo = jQuery("#<%=ddlSubCategory.ClientID %>").val().split('#')[6];
                obj.VisitNo = jQuery.trim(jQuery("#<%=txtVisitNo.ClientID %>").val());
                obj.FileName = jQuery("#<%=lblFileName.ClientID %>").text();
                obj.isTATDefine = jQuery("#<%=ddlSubCategory.ClientID %>").val().split('#')[4];
                if (jQuery("#<%=ddlSubCategory.ClientID %>").val().split('#')[4] == "0")
                    obj.resolveDateTime = jQuery("#<%=txtResolveDate.ClientID %>").val() + " " + jQuery("#<%=txtResolveTime.ClientID %>").val();
                else
                    obj.resolveDateTime = "0001-01-01 00:00:00";
                obj.isTagEmployeeDefine = jQuery("#<%=ddlSubCategory.ClientID %>").val().split('#')[5];
                obj.isDefaultTagEmployeeDefine = jQuery("#<%=ddlSubCategory.ClientID %>").val().split('#')[13];
                if (jQuery("#<%=ddlSubCategory.ClientID %>").val().split('#')[5] == "0" && jQuery("#<%=ddlSubCategory.ClientID %>").val().split('#')[13] == "0")
                    obj.AssignID = jQuery("#hdEmployeeID").val();
                else
                    obj.AssignID = 0;
                if (jQuery("#<%=ddlSubCategory.ClientID %>").val().split('#')[7] == 1)
                    obj.DepartmentID = jQuery("#ddlDepartment").val();
                else
                    obj.DepartmentID = 0;

                if (jQuery("#lblTicketID").text() != "") {
                    obj.OldTicketID = jQuery("#lblTicketID").text();
                }
                else {
                    obj.OldTicketID = 0;
                }


                jQuery.ajax({
                    type: "POST",
                    url: "NewTicket.aspx/Save",
                    data: "{query:'" + JSON.stringify(obj) + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (result) {
                        var res = jQuery.parseJSON(result.d);
                        if (res.Status == "1") {
                            jQuery('#viewticketid').text(res.msg);
                            jQuery('#NewticketModal').show();
                            jQuery('#spnTicketStatus').text('Ticket Generated Successfully');
                            clear();

                        }
                        else if (result.d == "2")
                            showerrormsg("Please Enter Valid Resolve DateTime");
                        else if (result.d == "3")
                            showerrormsg("Please Enter Valid SIN No.");
                        else if (result.d == "4")
                            showerrormsg("Please Enter valid UHID No.");
                        else if (result.d == "5")
                            showerrormsg("Please Enter Valid Visit No.");
                        else if (result.d == "6")
                            showerrormsg("Ticket Status Changed,So Record Not Updated");
                        else if (res.Status == "7") {
                            jQuery('#viewticketid').text(res.msg);
                            jQuery('#NewticketModal').show();
                            jQuery('#spnTicketStatus').text('Ticket Updated Successfully');
                            clear();
                            Search('0');
                        }
                        if (jQuery("#lblTicketID").text() == "") {
                            jQuery('#btnSave').removeAttr('disabled').val('Save');
                        }
                        else
                            jQuery('#btnSave').removeAttr('disabled').val('Update');
                    },
                    failure: function (response) {
                        jQuery('#btnSave').removeAttr('disabled').val('Save');
                    }
                });

            }
        }

        function IsValid() {
            var con = 0;
            if (jQuery("#<%=ddlGroup.ClientID %>").val() == "0") {
                showerrormsg("Please Select Group");
                jQuery("#<%=ddlGroup.ClientID %>").focus();
                con = 1;
                return con;
            }
            if (jQuery("#<%=ddlCategory.ClientID %>").val() == "0") {
                showerrormsg("Please Select Category");
                jQuery("#<%=ddlCategory.ClientID %>").focus();
                con = 1;
                return con;
            }
            if (jQuery("#<%=ddlSubCategory.ClientID %>").val() == "0") {
                showerrormsg("Please Select SubCategory");
                jQuery("#<%=ddlSubCategory.ClientID %>").focus();
                con = 1;
                return con;
            }
            if (jQuery("#<%=ddlQueries.ClientID %>").val() == "0") {
                showerrormsg("Please Select Predefined Query");
                jQuery("#<%=ddlQueries.ClientID %>").focus();
                con = 1;
                return con;
            }
            if (jQuery.trim(jQuery("#<%=txtSub.ClientID %>").val()) == "") {
                showerrormsg("Please Enter Subject.");
                con = 1;
                return con;
            }
            if (jQuery.trim(jQuery("#<%=txtDetail.ClientID %>").val()) == "") {
                showerrormsg("Please Enter Details.");
                jQuery("#<%=txtDetail.ClientID %>").focus();
                con = 1;
                return con;
            }
            if (jQuery("#<%=ddlSubCategory.ClientID %>").val().split('#')[8] == "1" && jQuery.trim(jQuery("#<%=txtVialId.ClientID %>").val()) == "") {
                showerrormsg("Please Enter SIN No.");
                jQuery("#<%=txtVialId.ClientID %>").focus();
                con = 1;
                return con;
            }

            if (jQuery("#<%=ddlSubCategory.ClientID %>").val().split('#')[10] == "1" && jQuery.trim(jQuery("#<%=txtRegNo.ClientID %>").val()) == "") {
                showerrormsg("Please Enter UHID No.");
                jQuery("#<%=txtRegNo.ClientID %>").focus();
                con = 1;
                return con;
            }
            if (jQuery("#<%=ddlSubCategory.ClientID %>").val().split('#')[9] == "1" && jQuery.trim(jQuery("#<%=txtVisitNo.ClientID %>").val()) == "") {
                showerrormsg("Please Enter Visit No.");
                jQuery("#<%=txtVisitNo.ClientID %>").focus();
                con = 1;
                return con;
            }

            if (jQuery("#<%=ddlSubCategory.ClientID %>").val().split('#')[11] == "1" && jQuery("#<%=ddlDepartment.ClientID %>").val() == "0") {
                showerrormsg("Please Select Department");
                jQuery("#<%=ddlDepartment.ClientID %>").focus();
                con = 1;
                return con;
            }
            if (jQuery("#<%=ddlSubCategory.ClientID %>").val().split('#')[12] == "1" && (jQuery("#<%=ddlInvestigation.ClientID %>").val() == "0" || jQuery("#<%=ddlInvestigation.ClientID %>").val() == null)) {
                showerrormsg("Please Select Test Name");
                jQuery("#<%=ddlInvestigation.ClientID %>").focus();
                con = 1;
                return con;
            }


            if (jQuery("#<%=ddlSubCategory.ClientID %>").val().split('#')[4] == "0") {
                if (jQuery.trim(jQuery("#<%=txtResolveDate.ClientID %>").val()) == "") {
                    showerrormsg("Please Enter Resolve Date");
                    jQuery("#<%=txtResolveDate.ClientID %>").focus();
                    con = 1;
                    return con;
                }
                if (jQuery.trim(jQuery("#<%=txtResolveTime.ClientID %>").val()) == "") {
                    showerrormsg("Please Enter Resolve Time");
                    jQuery("#<%=txtResolveTime.ClientID %>").focus();
                    con = 1;
                    return con;
                }
            }

            if (jQuery("#<%=ddlSubCategory.ClientID %>").val().split('#')[5] == "0" && jQuery("#<%=ddlSubCategory.ClientID %>").val().split('#')[13] == "0") {
                if (jQuery.trim(jQuery("#<%=txtResolveDate.ClientID %>").val()) == "" || jQuery("#hdEmployeeID").val() == "") {
                    showerrormsg("Please Enter Tag Employee ");
                    jQuery("#<%=txtEmployeeName.ClientID %>").focus();
                    con = 1;
                    return con;
                }
            }


            return con;
        }

        function clear() {
            jQuery("#<%=ddlGroup.ClientID %>").prop('selectedIndex', 0);
            jQuery("#<%=ddlGroup.ClientID %>").trigger('chosen:updated');
            jQuery("#<%=ddlCategory.ClientID %> option").remove();
            jQuery("#<%=ddlCategory.ClientID %>").trigger('chosen:updated');
            jQuery("#<%=ddlSubCategory.ClientID %> option").remove();
            jQuery("#<%=ddlSubCategory.ClientID %>").trigger('chosen:updated');
            jQuery("#<%=ddlQueries.ClientID %> option").remove();
            jQuery("#<%=ddlQueries.ClientID %>").trigger('chosen:updated');
            jQuery("#<%=txtSub.ClientID %>,#<%=txtDetail.ClientID %>,#<%=txtVialId.ClientID %>,#<%=txtRegNo.ClientID %>,#txtEmployeeName,#txtVisitNo").val('');
            jQuery("#<%=ddlInvestigation.ClientID %>").val('0');
            jQuery("#<%=ddlInvestigation.ClientID %>").trigger('chosen:updated');
            jQuery("#<%=lblFileName.ClientID %>,#spnScreen").text('');


            jQuery("#<%=ddlDepartment.ClientID %>").prop('selectedIndex', 0);
            jQuery("#<%=ddlDepartment.ClientID %>").trigger('chosen:updated');
            jQuery("#trTagEmployee,#trResolveDateTime,#ShowBarcodeNumber,#ShowPatientID,#ShowVisitNo,#ShowInvestigationID,#ShowDepartment").hide();
            jQuery("#hdEmployeeID").val('');

            jQuery("#lblremaingCharacters").html(MaxLength - ($("#<%=txtDetail.ClientID %>").val().length));
            jQuery("#lblTicketID").text('');
        }
    </script>

    <script type="text/javascript">
        var MaxLength = 500;
        jQuery(document).ready(function () {

            jQuery("#<% =txtDetail.ClientID%>").bind("cut copy paste", function (event) {
                event.preventDefault();
            });
            jQuery("#lblremaingCharacters").html(MaxLength - ($("#<%=txtDetail.ClientID %>").val().length));
            jQuery("#<%=txtDetail.ClientID %>").bind("keyup keydown", function () {
                var characterInserted = $(this).val().length;
                if (characterInserted > MaxLength) {
                    jQuery(this).val(jQuery(this).val().substr(0, MaxLength));
                }
                var characterRemaining = MaxLength - characterInserted;
                jQuery("#lblremaingCharacters").html(characterRemaining);
            });

            jQuery('#<%=txtDetail.ClientID%>').bind("keypress", function (e) {
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
        function showerrormsg(msg) {
            jQuery('#msgField').html('');
            jQuery('#msgField').append(msg);
            jQuery(".alert").css('background-color', 'red');
            jQuery(".alert").removeClass("in").show();
            jQuery(".alert").delay(1500).addClass("in").fadeOut(1000);
        }
        function PredefinedQueries() {

            jQuery("#<%=ddlQueries.ClientID %> option").remove();
            jQuery("#<%=ddlQueries.ClientID %>").trigger('chosen:updated');
            if (jQuery("#<%=ddlGroup.ClientID %>").val() != 0 && jQuery("#<%=ddlCategory.ClientID %>").val() != 0 && $("#<%=ddlSubCategory.ClientID %>").val() != 0) {
                jQuery.ajax({
                    url: "../CallCenter/Services/CallCenter.asmx/BindPredefinedQueries",
                    data: '{GroupID: "' + $("#<%=ddlGroup.ClientID %>").val() + '", CategoryID: "' + $("#<%=ddlCategory.ClientID %>").val() + '",SubCategoryID: "' + jQuery("#<%=ddlSubCategory.ClientID %>").val().split('#')[0] + '"}', // parameter map
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        var ItemData = jQuery.parseJSON(result.d);
                        if (ItemData.length == 0) {
                            jQuery("#<%=ddlQueries.ClientID %>").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                        }
                        else {
                            jQuery("#<%=ddlQueries.ClientID %>").append(jQuery("<option></option>").val("0").html("---Select---"));
                            for (i = 0; i < ItemData.length; i++) {
                                $("#<%=ddlQueries.ClientID %>").append(jQuery("<option></option>").val(ItemData[i].ID).html(ItemData[i].Subject));
                            }
                        }
                        jQuery("#<%=ddlQueries.ClientID %>").trigger('chosen:updated');
                    },
                    error: function (xhr, status) {

                    }
                });
            }
        }

    </script>
    <script type="text/javascript">
        jQuery("#txtEmployeeName")
              .bind("keydown", function (event) {
                  if (event.keyCode === $.ui.keyCode.TAB &&
                     jQuery(this).autocomplete("instance").menu.active) {
                      event.preventDefault();
                  }
              })
              .autocomplete({
                  autoFocus: true,
                  source: function (request, response) {
                      $.getJSON("NewTicket.aspx?cmd=GetEmpList", {
                          EmpName: extractLast1(request.term)
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
                      jQuery("#<%=txtEmployeeName.ClientID%>").val(ui.item.label);
                      jQuery("#hdEmployeeID").val(ui.item.value);
                      return false;
                  },
              });
              function extractLast1(term) {
                  return term;
              }
    </script>
    <script>
        $(function () {
            $('.popup-close,#btnclose').click(function () {
                $('#viewticketid').text('');
                $('#NewticketModal').hide();
            });


        });
    </script>
    <script type="text/javascript">
        $(function () {
            if ('<%=Request.QueryString["FileName"]!=null%>') {
                bindCategory();
            }
        });
        function bindCategory() {
            jQuery("#ddlCategory option").remove();
            jQuery("#ddlSubCategory option").remove();
            jQuery("#ddlQueries option").remove();
            jQuery("#ddlCategory,#ddlSubCategory,#ddlQueries").trigger('chosen:updated');
            jQuery("#ShowBarcodeNumber,#ShowPatientID,#ShowVisitNo,#ShowInvestigationID,#ShowDepartment,#trTagEmployee,#trResolveDateTime").hide();
            jQuery("#txtSub,#txtDetail,#txtVialId,#txtRegNo,#txtVisitNo,#txtEmployeeName,#hdEmployeeID").val('');
            jQuery("#ddlInvestigation").prop('selectedIndex', 0);
            jQuery("#ddlInvestigation").trigger('chosen:updated');
            jQuery("#ddlDepartment").prop('selectedIndex', 0);
            jQuery("#ddlDepartment").trigger('chosen:updated');

            if (jQuery('#<%=ddlGroup.ClientID%>').val() != 0) {
                jQuery.ajax({
                    type: "POST",
                    url: "NewTicket.aspx/bindCategory",
                    data: JSON.stringify({ GroupID: jQuery('#<%=ddlGroup.ClientID%>').val() }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (data) {
                        if (data.d != "") {
                            var categoryResult = jQuery.parseJSON(data.d);
                            jQuery("#ddlCategory").append(jQuery("<option></option>").val("0").html("---Select---"));
                            for (i = 0; i < categoryResult.length; i++) {
                                jQuery("#ddlCategory").append(jQuery("<option></option>").val(categoryResult[i].ID).html(categoryResult[i].CategoryName));
                            }
                            jQuery("#<%=ddlCategory.ClientID %>").trigger('chosen:updated');
                            if ('<%=Request.QueryString["FileName"]!=null%>' && jQuery("#lblTicketID").text() == "") {
                                jQuery("#<%=ddlCategory.ClientID %>").prop('selectedIndex', 4);
                                jQuery("#<%=ddlCategory.ClientID %>").trigger('chosen:updated');
                                bindSubcategory();

                            }
                        }
                    },
                    error: function (result) {
                    }
                });
            }
        }
        function bindDepartment() {
            if (jQuery("#<%=ddlDepartment.ClientID %> option").length == 0) {
                jQuery.ajax({
                    url: "../CallCenter/Services/CallCenter.asmx/BindDepartment",
                    data: '{}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        var deptData = jQuery.parseJSON(result.d);
                        jQuery("#<%=ddlDepartment.ClientID %>").append(jQuery("<option></option>").val("0").html("---Select---"));
                        for (i = 0; i < deptData.length; i++) {
                            $("#<%=ddlDepartment.ClientID %>").append(jQuery("<option></option>").val(deptData[i].DepartmentID).html(deptData[i].DepartmentName));
                        }

                        jQuery("#<%=ddlDepartment.ClientID %>").trigger('chosen:updated');
                        $('#ddlDepartment_chosen').css({ "width": "450px" });
                    },
                    error: function (xhr, status) {
                    }
                });
            }
        }
        function bindItem() {
            jQuery("#<%=ddlInvestigation.ClientID %> option").remove();
            jQuery.ajax({
                url: "NewTicket.aspx/bindinv",
                data: JSON.stringify({ Department: jQuery('#<%=ddlDepartment.ClientID%> option:selected').text() }),
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    var ItemData = jQuery.parseJSON(result.d);
                    if (ItemData.length == 0) {
                        jQuery("#<%=ddlInvestigation.ClientID %>").append(jQuery("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        jQuery("#<%=ddlInvestigation.ClientID %>").append(jQuery("<option></option>").val("0").html("---Select---"));
                        for (i = 0; i < ItemData.length; i++) {
                            console.log('call');
                            $("#<%=ddlInvestigation.ClientID %>").append(jQuery("<option></option>").val(ItemData[i].id).html(ItemData[i].VALUE));
                             }
                         }
                    jQuery("#<%=ddlInvestigation.ClientID %>").trigger('chosen:updated');
                    //$('#ddlDepartment_chosen').css({ "width": "450px" });
                },
                error: function (xhr, status) {
                }
            });
        }
    </script>
  
   
   
      <script type="text/javascript">

          $(function () {
           var table=$('#gridtable').DataTable();
          });

          function Search(status) {
              if (status == 0)
                  status = jQuery("#ddlStatus").val();
              PageMethods.searchOldTicket(jQuery("#txtFromDate").val(), jQuery("#txtToDate").val(), status, onSucessOldTicket, onFailureOldTicket);
          }
          function onSucessOldTicket(result) {
              var res = $.parseJSON(result);
              table = $('#gridtable').DataTable();
              table.destroy()
              table = $('#gridtable').DataTable({
                  "scrollY": "300px",
                  "scrollX": false,
                  data: res,
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
                      if (data.StatusID == "1") {
                          $('td', row).css('background-color', '#768aa3');
                      }
                      if (data.StatusID == "2") {
                          $('td', row).css('background-color', '#ffd2d2');
                      }
                      if (data.StatusID == "3") {
                          $('td', row).css('background-color', '#00cccc');
                      }
                      if (data.StatusID == "4") {
                          $('td', row).css('background-color', '#ff7f24');
                      }
                      if (data.StatusID == "5") {
                          $('td', row).css('background-color', '#ccffcc');
                      }
                      if (data.StatusID == "6") {
                          $('td', row).css('background-color', '#6993ca');
                      }
                      if (data.StatusID == "7") {
                          $('td', row).css('background-color', '#ffd2d2');
                      }                       
                  },
                  "columnDefs": [                            
                           { "width": "10px", "targets": 0 }                          
                  ],
                  deferRender: true,
                  columns: [
                      {
                          "class": 'details-control',
                          "orderable": false,
                          "data": null,
                          "defaultContent": ''
                      },
                      { 'data': 'GroupName', "orderable": "true" },
                      { 'data': 'CategoryName', "orderable": "true" },
                      { 'data': 'SubCategoryName', "orderable": "true" },
                      { 'data': 'Subject', "orderable": "true" },
                       { 'data': 'dtAdd', "orderable": "true" },
                         {
                             data: "ID", "bSearchable": true,
                             bSortable: true,
                             mRender: function (data, type, row) {
                                 if (row.StatusID == 1)
                                     return ' <a href="#" class="edit">Edit</a>';
                                 else
                                     return "";
                             }
                         },

                  ]
              });


              $('#gridtable').find('tbody').off('click', 'tr td .edit');
              $('#gridtable').find('tbody').on('click', 'tr td .edit', function () {
                  table = $('#gridtable').DataTable();
                  var data = table.row($(this).parent("td")).data();
                  if (data != "") {
                      EditSearchRecord(data);
                  }
              });

              $('#gridtable').find('tbody').off('click', 'tr td.details-control');
              $('#gridtable').find('tbody').on('click', 'tr td.details-control', function () {
                  var tr = $(this).closest('tr');
                  var row = table.row(tr);
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
          }
          function onFailureOldTicket(result) {

          }
        
          

          function format(d) {
              BindReplyes(d.TicketID);
              var data = $('#divReplyOutput').html();
              return data;

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
           function EditSearchRecord(row) {
               
               jQuery.blockUI({ message: 'Please Wait.....\n<img src="../../App_Images/Progress.gif" />' });
               jQuery("#btnSave").val('Update');
               jQuery("#lblTicketID").text(row.TicketID);
               jQuery("#ddlGroup").val(row.GroupID)
               jQuery("#<%=ddlGroup.ClientID %>").trigger('chosen:updated');


            bindCategory();
            jQuery("#ddlCategory").val(row.CategoryId)
            jQuery("#<%=ddlCategory.ClientID %>").trigger('chosen:updated');

            bindSubcategory();
            jQuery("#ddlSubCategory").val(row.SubCategoryID);
            jQuery("#<%=ddlSubCategory.ClientID %>").trigger('chosen:updated');


            ChangeSubcategory();


            jQuery("#ddlQueries").val(row.QueryID);
            jQuery("#<%=ddlQueries.ClientID %>").trigger('chosen:updated');
               jQuery("#txtSub").val(row.Subject);


            if (jQuery("#<%=ddlSubCategory.ClientID %>").val().split('#')[7] == "1") {
                jQuery("#ddlDepartment").val(row.DepartmentID);
                jQuery("#<%=ddlDepartment.ClientID %>").trigger('chosen:updated');
                if (row.ItemID != "") {
                  bindItem();
                  jQuery("#ddlInvestigation").val(row.ItemID);
              }

          }


          jQuery("#txtVialId").val(row.VialId);
          jQuery("#txtRegNo").val(row.RegNo);
          jQuery("#txtVisitNo").val(row.VisitNo);

          jQuery("#txtResolveDate").val(row.resolveDate);
          jQuery("#txtResolveTime").val(row.resolveTime);

          PageMethods.searchOldTicketDetail(row.TicketID, onSucessOldDetail, onFailureOldTicket);

          if (row.Attachment= "0") {
              PageMethods.searchOldTicketAttachment(row.TicketID, onSucessOldAttachment, onFailureOldTicket);
          }
          jQuery.unblockUI();
      }
      function onSucessOldDetail(result) {
          jQuery("#txtDetail").val(result);
      }
      function onSucessOldAttachment(result) {

      }
      function Cancel() {
          jQuery("#btnSave").val('Save');
          clear();
          jQuery("#lblTicketID").text('');
      }
    </script>

    <style type="text/css">
         td.details-control {
            background: url('../../App_Images/details_open.png') no-repeat left center;
            cursor: pointer;
        }

        tr.shown td.details-control {
            background: url('../../App_Images/details_close.png') no-repeat left center;
        }
    </style>
<script type="text/javascript">
         $(document).on("mouseenter", "a.im", function (e) {
             //console.log('call');
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
</asp:Content>

