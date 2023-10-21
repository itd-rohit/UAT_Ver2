<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="IndentIssue.aspx.cs" Inherits="Design_Store_IndentIssue" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css"  />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css"  />
       <webopt:BundleReference ID="BundleReference3" runat="server" Path="~/Scripts/fancybox/jquery.fancybox.css" />
     
     <%: Scripts.Render("~/bundles/JQueryStore") %>
    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <link href="../../App_Style/multiple-select.css" rel="stylesheet" /> 
      
     <div id="Pbody_box_inventory" >
         <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
      
        </Ajax:ScriptManager>
          <div class="POuter_Box_Inventory" >
              <div class="row">
                <div class="col-md-24" style="text-align: center">
                   <b> Stock Indent Search /Issue</b>
                </div>
            </div>
               <div class="row" style="display:none;">
                <div class="col-md-24" style="text-align: center">
                    <b><asp:RadioButtonList ID="rdoIndentType" runat="server" Width="100px" onchange="setIndentType();" RepeatDirection="Horizontal">
                              <asp:ListItem Text="SI" Value="SI" Selected="True"></asp:ListItem>
                              <asp:ListItem Text="PI" Value="PI"></asp:ListItem>
                             </asp:RadioButtonList></b> 
                    </div>
            </div>
            
              </div>


         <div class="POuter_Box_Inventory" >
           
                 
               <div class="row">
            <div class="col-md-3">
                <label class="pull-left">Current Location   </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-6">
                <asp:DropDownList ID="ddllocation" runat="server" onchange="bindindentfromlocation()"></asp:DropDownList> 
                </div>
<div class="col-md-3">
                <label class="pull-left">Indent Date From  </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-2"> <asp:TextBox ID="txtentrydatefrom" runat="server" ReadOnly="true" />
                        <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtentrydatefrom" Format="dd-MMM-yyyy"></cc1:CalendarExtender>


                 </div><div class="col-md-2"></div>
<div class="col-md-3">
                <label class="pull-left">Indent Date To  </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-2"> 

                <asp:TextBox ID="txtentrydateto" runat="server"  ReadOnly="true" />
                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtentrydateto" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                   </div>

  </div>
              <div class="row">
            <div class="col-md-3">
                <label class="pull-left">Zone </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-6">
                     <asp:ListBox ID="lstZone" CssClass="multiselect" SelectionMode="Multiple" runat="server" ClientIDMode="Static" onchange="bindState($(this).val());bindindentfromlocation();"></asp:ListBox>
                </div>
                   <div class="col-md-3">
                <label class="pull-left">State </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-5">
               <asp:ListBox ID="lstState" CssClass="multiselect" SelectionMode="Multiple" runat="server"  ClientIDMode="Static" onchange="bindindentfromlocation()"></asp:ListBox>
</div>
                   <div class="col-md-2">
                <label class="pull-left">Centre Type </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-5">
                         <asp:ListBox ID="lstCentreType" CssClass="multiselect" SelectionMode="Multiple"  runat="server" ClientIDMode="Static" onchange="bindindentfromlocation()"></asp:ListBox>

                </div>
                  </div>


              <div class="row">
            <div class="col-md-3">
                <label class="pull-left">Issue To Location </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-6">
                <asp:DropDownList ID="ddllocationfrom"  runat="server" ></asp:DropDownList>

                 </div>
 
</div>

              <div class="row">
             <div class="col-md-3">
                <label class="pull-left">Indent No. </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-6">
                <asp:TextBox ID="txtindentno" runat="server" Width="160px"></asp:TextBox>

                   </div>
                   <div class="col-md-3">
                <label class="pull-left">Indent Status </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-5">
                <asp:DropDownList ID="ddlindenttype" runat="server"   Width="148px">  <asp:ListItem Text="New" Value="New" />
                                   <asp:ListItem Text="Issued" Value="Issued" />
                            <asp:ListItem Text="Close" Value="Close" />
                            <asp:ListItem Text="Reject" Value="Reject" />
                            <asp:ListItem Text="Partial Issue" Value="Partial Issue" />
                                    <asp:ListItem Text="Partial Receive" Value="Partial Receive" />
                            <asp:ListItem Text="All" Value="All" />
                        </asp:DropDownList>
                    </div>
                   <div class="col-md-2">
                    <label class="pull-left">Action </label>
                <b class="pull-right">:</b>
            </div>

                  <div class="col-md-5">
                        <asp:DropDownList ID="ddlaction" runat="server" Width="100" Enabled="false">
                              <asp:ListItem Value=""></asp:ListItem>
                               <asp:ListItem Value="Maker">Maked</asp:ListItem>
                                <asp:ListItem Value="Checker">Checked</asp:ListItem>
                                <asp:ListItem Value="Approval" Selected="True">Approved</asp:ListItem>
                          </asp:DropDownList>
 </div> </div>



              <div class="row">

 <div class="col-md-12" style="text-align: right">
     <input type="button" value="Search" class="searchbutton" onclick="searchdata()" />    
      </div>

                   <div class="col-md-12">
                  <table width="100%">
                <tr>
                    <td style="width: 15%;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: bisque;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>New</td>
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: white;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Issued</td>
                     <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: #90EE90;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Close</td>
                    <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: Pink;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Reject</td>
                      <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: yellow;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Partial Issue</td>

                     <td style="width: 15px; border-right: black thin solid; border-top: black thin solid;
                                border-left: black thin solid; border-bottom: black thin solid; background-color: lightgray;">
                                &nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td>Partial Receive</td>
                </tr>
            </table>
                       </div>
                   </div>
             
              </div>


         <div class="POuter_Box_Inventory" >
            
                 <div class="Purchaseheader">
                     Indent Detail
                      </div>
              <div class="row">
            <div class="col-md-24">
                 <div style="width:100%;max-height:375px;overflow:auto;">
                <table id="tblitemlist" style="width:100%;border-collapse:collapse;text-align:left;">
                    <tr id="triteheader">
                                        
                                        <td class="GridViewHeaderStyle" style="width:20px;">#</td>
                                        <td class="GridViewHeaderStyle"  style="width:50px;">View Item</td>
                                        <td class="GridViewHeaderStyle">Indent No.</td>
                                        <td class="GridViewHeaderStyle">Indent Date</td>
                                        <td class="GridViewHeaderStyle">Indent From Location</td>
                                        <td class="GridViewHeaderStyle">Indent To Location</td>                                       
                                        <td class="GridViewHeaderStyle">Created User</td>
                                        <td class="GridViewHeaderStyle">Narration</td>
                                        <td class="GridViewHeaderStyle">Status</td>
                                        <td class="GridViewHeaderStyle">ExpectedDate</td>
                                        <td class="GridViewHeaderStyle">Action Type</td>                      
                                        <td class="GridViewHeaderStyle" style="width:20px;">Issue</td>
                                        <td class="GridViewHeaderStyle" style="width:20px;">Print</td>                                        
                                         <td class="GridViewHeaderStyle" style="width:20px;">Invoice<br /> Print </td>
                                         <td class="GridViewHeaderStyle" style="width:20px;">Address<br /> Print </td>
                                         <td class="GridViewHeaderStyle" style="width:20px;">Close</td>         
                                                                                                                   
                        </tr>
                </table>

                </div>
              </div>
                  </div>        
             </div>
         </div>
          
       <div id="popup_box" style="background-color:lightgreen;height:120px;text-align:center;width:340px;">
    <div id="showpopupmsg" style="font-weight:bold;"></div>
             <br />

           <b><span style="color:red;"> Reason :</span> </b>&nbsp;&nbsp;<asp:TextBox ID="txtrejectre" runat="server" Width="200px" />
           <br />
        <span id="indentno" style="display:none;"></span>
             <input type="button" class="searchbutton" value="Yes"  onclick="reject();" />
              <input type="button" class="resetbutton" value="No" onclick="unloadPopupBox()" />
    </div>
    <script type="text/javascript">
        function openmypopup(href) {
            var width = '1280px';
            $.fancybox({
                'background': 'none',
                'hideOnOverlayClick': true,
                'overlayColor': 'gray',
                'width': width,
                'height': '800px',
                'autoScale': false,
                'autoDimensions': false,
                'transitionIn': 'elastic',
                'transitionOut': 'elastic',
                'speedIn': 6,
                'speedOut': 6,
                'href': href,
                'overlayShow': true,
                'type': 'iframe',
                'opacity': true,
                'centerOnScroll': true,
                'overflow-y': 'auto',
                'onComplete': function () {
                },
                afterClose: function () {
                }
            });
        }
        $(function () {
            $('[id*=lstZone]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=lstState]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            $('[id*=lstCentreType]').multipleSelect({
                includeSelectAllOption: true,
                filter: true, keepOpen: false
            });
            bindcentertype();
            bindZone();
        });
        function bindcentertype() {
            jQuery('#<%=lstCentreType.ClientID%> option').remove();
            jQuery('#lstCentreType').multipleSelect("refresh");
            serverCall('StoreLocationMaster.aspx/bindcentertype', {  }, function (response) {
                typedata = jQuery.parseJSON(response);
                for (var a = 0; a <= typedata.length - 1; a++) {
                    jQuery('#lstCentreType').append($("<option></option>").val(typedata[a].ID).html(typedata[a].Type1));
                }

                jQuery('[id*=lstCentreType]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
            });           
        }

        function bindZone() {
            jQuery('#<%=lstZone.ClientID%> option').remove();
            jQuery('#lstZone').multipleSelect("refresh");
            serverCall('../Common/Services/CommonServices.asmx/bindBusinessZone', {}, function (response) {
                BusinessZoneID = jQuery.parseJSON(response);
                for (i = 0; i < BusinessZoneID.length; i++) {
                    jQuery('#lstZone').append($("<option></option>").val(BusinessZoneID[i].BusinessZoneID).html(BusinessZoneID[i].BusinessZoneName));
                }
                $('[id*=lstZone]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
            });
            
        }


        function bindState(BusinessZoneID) {
            jQuery('#<%=lstState.ClientID%> option').remove();
              jQuery('#lstState').multipleSelect("refresh");
              if (BusinessZoneID != "") {
                  serverCall('StoreLocationMaster.aspx/bindState', { BusinessZoneID: BusinessZoneID.toString() }, function (response) {
                      stateData = jQuery.parseJSON(response);
                      for (i = 0; i < stateData.length; i++) {
                          jQuery("#lstState").append(jQuery("<option></option>").val(stateData[i].ID).html(stateData[i].State));
                      }
                      jQuery('[id*=lstState]').multipleSelect({
                          includeSelectAllOption: true,
                          filter: true, keepOpen: false
                      });

                  });
                  
              }
             
          }

        function unloadPopupBox() {    // TO Unload the Popupbox
            $('#indentno').html('');

            $('#popup_box').fadeOut("slow");
            $("#Pbody_box_inventory").css({ // this is just for style        
                "opacity": "1"
            });

            $('#<%=txtrejectre.ClientID%>').val('');
        }

       
       


        function bindindentfromlocation() {
            if ($('#<%=ddllocation.ClientID%>').val() == "0") {
                $("#<%=ddllocationfrom.ClientID%> option").remove();
                $("#<%=ddllocationfrom.ClientID%>").append($("<option></option>").val("0").html("Select From Location"));
                return;
            }
            var dropdown = $("#<%=ddllocationfrom.ClientID%>");
            $("#<%=ddllocationfrom.ClientID%> option").remove();

            var StateID = jQuery('#lstState').val().toString();
            var TypeId = jQuery('#lstCentreType').val().toString();
            var ZoneId = jQuery('#lstZone').val().toString();
          
            serverCall('IndentIssue.aspx/bindindentfromlocation', { tolocation:$('#<%=ddllocation.ClientID%>').val(),TypeId: TypeId,ZoneId:ZoneId,StateID: StateID,IndentType:$("#<%=rdoIndentType.ClientID%>").find(":checked").val() }, function (response) {

                PanelData = $.parseJSON(response);
                if (PanelData.length == 0) {
                    dropdown.append($("<option></option>").val("0").html("Select Issue To Location"));
                }
                else {
                    if ($("#<%=rdoIndentType.ClientID%>").find(":checked").val() == 'SI') {
                            dropdown.append($("<option></option>").val("0").html("Select Issue To Location"));
                        }
                        for (i = 0; i < PanelData.length; i++) {
                            dropdown.append($("<option></option>").val(PanelData[i].locationid).html(PanelData[i].location));
                        }
                    }
            });

           
        }

    </script>

    <script type="text/javascript">
        var CanClose = '<%=CanClose %>';
        function searchdata() {
            var length = $('#<%=ddllocation.ClientID%> > option').length;
            if (length == 0) {
                toast("Error", "No Location Found For Current User..!","");
                $('#<%=ddllocation.ClientID%>').focus();
                return false;
            }

            var fromlocation = $("#<%=ddllocationfrom.ClientID%>").val();
            var fromdate = $('#<%=txtentrydatefrom.ClientID%>').val();
            var todate = $('#<%=txtentrydateto.ClientID%>').val();
            var tolocation = $("#<%=ddllocation.ClientID%>").val();
            var indentno = $("#<%=txtindentno.ClientID%>").val();
            var indenttype = $("#<%=ddlindenttype.ClientID%>").val();         
            $('#tblitemlist tr').slice(1).remove();
            serverCall('IndentIssue.aspx/SearchData', { tolocation: tolocation,fromdate:fromdate,todate:todate,fromlocation:fromlocation,indentno:indentno,indenttype:indenttype ,ActionType:$('#<%=ddlaction.ClientID%>').val() ,IsSIIndentType:$("#<%=rdoIndentType.ClientID%>").find(":checked").val() }, function (response) {
                ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast("Error", "No Indent Found","");
                }
                else {
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        var $myData = [];
                        $myData.push("<tr style='background-color:");$myData.push(ItemData[i].Rowcolor); $myData.push(";' id='"); $myData.push(ItemData[i].indentno);$myData.push("'>");
                        $myData.push('<td class="GridViewLabItemStyle" >');$myData.push(parseInt(i + 1));$myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle"  id="tddetail1" ><img src="../../App_Images/plus.png" style="cursor:pointer;" onclick="showdetail(this)" /></td>');
                        $myData.push('<td class="GridViewLabItemStyle" >');$myData.push(ItemData[i].indentno);$myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >');$myData.push( ItemData[i].IndentDate);$myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >');$myData.push( ItemData[i].FromLocation);$myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >');$myData.push( ItemData[i].ToLocation);$myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >');$myData.push( ItemData[i].Username);$myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >');$myData.push( ItemData[i].Narration);$myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >');$myData.push( ItemData[i].Status);$myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" >');$myData.push( ItemData[i].ExpectedDate);$myData.push('</td>');
                        if (ItemData[i].ActionType == "Maker") {
                            $myData.push('<td class="GridViewLabItemStyle" style="background-color:white;font-weight:bold;" >Maked</td>');
                        }
                        else if (ItemData[i].ActionType == "Checker") {
                            $myData.push('<td class="GridViewLabItemStyle" style="background-color:aqua;font-weight:bold;" >Checked</td>');
                        }
                        else {
                            $myData.push('<td class="GridViewLabItemStyle" style="background-color:palegreen;font-weight:bold;">Approved</td>');
                        }                       
                        $myData.push('<td class="GridViewLabItemStyle" style="text-align:center;" >');
                        if ($("#<%=rdoIndentType.ClientID%>").find(":checked").val() == "SI" && ItemData[i].ActionType == "Approval") {
                            if (ItemData[i].Status == 'New' || ItemData[i].Status == 'Partial Issue' || ItemData[i].Status == 'Partial Receive') {
                                $myData.push('<img src="../../App_Images/post.gif" style="cursor:pointer;" onclick="issueme(this)" />');
                            }
                        }
                        $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" style="text-align:center;" ><img src="../../App_Images/print.gif" style="cursor:pointer;" onclick="printme(this)" />  </td>');
                        $myData.push('<td class="GridViewLabItemStyle" style="text-align:center;" >');
                        if (ItemData[i].Status != 'New' && ItemData[i].Status != 'Reject') {
                            $myData.push('<img src="../../App_Images/print.gif" style="cursor:pointer;" title="Print Invoice" onclick="printmeinvoice(this)" />');
                        }
                        $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" style="text-align:center;" >');
                        if (ItemData[i].Status != 'New' && ItemData[i].Status != 'Reject') {
                            $myData.push('<img src="../../App_Images/print.gif" style="cursor:pointer;" title="Print Invoice" onclick="printmeaddess(this)" />');
                        }
                        $myData.push('</td>');
                        $myData.push('<td class="GridViewLabItemStyle" style="text-align:center;" >');
                        if (CanClose == "1") {
                            if (ItemData[i].Status == 'New' || ItemData[i].Status == 'Partial Issue') {
                                $myData.push('<img src="../../App_Images/Delete.gif" style="cursor:pointer;" title="Close Indent" onclick="rejectme(this)" />');
                            }
                        }
                        $myData.push('</td>');
                        $myData.push('<td style="display:none;" id="tdlocid" >'); $myData.push(ItemData[i].tolocationid); $myData.push('</td>');
                        $myData.push('<td style="display:none;" id="tdIssueInvoiceNo" >'); $myData.push(ItemData[i].IssueInvoiceNo);$myData.push('</td>');
                        $myData.push("</tr>");
                        $myData = $myData.join("");
                        $('#tblitemlist').append($myData);
                    }
                }
            });        
        }     
        function printme(ctrl) {
            window.open('IndentReceipt.aspx?IndentNo=' + $(ctrl).closest('tr').attr("id"));
        }
        function printmeinvoice(ctrl) {
            var tdIssueInvoiceNo = $(ctrl).closest('tr').find("#tdIssueInvoiceNo").html();
            if (tdIssueInvoiceNo != "") {
                for (var a = 0; a <= tdIssueInvoiceNo.split(',').length - 1; a++) {
                    var BatchNumber = tdIssueInvoiceNo.split(',')[a];
                    window.open('IndentIssueReceipt.aspx?Type=1&BatchNumber=' + BatchNumber);
                }
            }
        }
        function printmeaddess(ctrl) {
            var tdIssueInvoiceNo = $(ctrl).closest('tr').attr("id");
            window.open('IndentIssueReceipt.aspx?Type=2&IndentNo=' + tdIssueInvoiceNo);                           
        }
        function rejectme(ctrl) {
            var indentid = $(ctrl).closest('tr').attr("id");
            $('#showpopupmsg').show();
            $('#showpopupmsg').html("Do You Want To Completely Close This Indent?");
            $('#popup_box').fadeIn("slow");
            $("#Pbody_box_inventory").css({
                "opacity": "0.3"
            });
            $('#indentno').html(indentid);
            $('#<%=txtrejectre.ClientID%>').val('');
        }
        function reject() {
            if ($('#<%=txtrejectre.ClientID%>').val() == "") {
                $('#<%=txtrejectre.ClientID%>').focus();
                toast("Error", "Please Enter Reason","");
                return;
            }
            serverCall('IndentIssue.aspx/RejectIndent', {IndentNo:$('#indentno').html(),Reason:$('#<%=txtrejectre.ClientID%>').val()}, function (response) {
                ItemData = response;
                unloadPopupBox();
                $('#ContentPlaceHolder1_ddlindenttype').val('Reject');
                toast("Success", "Indent Rejected.!","");
                searchdata();
            });
           
        }

        function showdetail(ctrl) {

            var id = $(ctrl).closest('tr').attr("id");
            var locationid = $(ctrl).closest('tr').find("#tdlocid").html();
            if ($('table#tblitemlist').find('#ItemDetail' + id).length > 0) {
                $('table#tblitemlist tr#ItemDetail' + id).remove();
                $(ctrl).attr("src", "../../App_Images/plus.png");
                return;
            }
           
            serverCall('IndentIssue.aspx/BindItemDetail', {IndentNo:id,locationid:locationid}, function (response) {
                ItemData = jQuery.parseJSON(response);
                if (ItemData.length == 0) {
                    toast("Error", "No Item Found","");
                }
                else {
                    var $myData = [];
                    $(ctrl).attr("src", "../../App_Images/minus.png");
                    $myData.push("<div style='width:99%;max-height:275px;overflow:auto;'><table style='width:99%' cellpadding='0' cellspacing='0' frame='box' rules='all' border='1'>");
                    $myData.push('<tr id="trheader" style="background-color:lightslategray;color:white;font-weight:bold;">');
                    $myData.push('<td  style="width:20px;">#</td>');
                    $myData.push('<td>Item Name</td>');
                    $myData.push('<td>Consume/Issue Unit</td>');
                    $myData.push('<td>Request Qty</td>');
                    $myData.push('<td>Approved Qty</td>');
                    $myData.push('<td>Issue Qty </td>');
                    $myData.push('<td>Receive Qty </td>');
                    $myData.push('<td>Rejected Qty</td>');
                    $myData.push('<td>Available Qty</td>');
                    for (var i = 0; i <= ItemData.length - 1; i++) {
                        $myData.push("<tr style='background-color:");$myData.push(ItemData[i].Rowcolor); $myData.push(";' id='"); $myData.push(ItemData[i].id);$myData.push( "'>");
                        $myData.push('<td >');$myData.push(parseInt(i + 1));$myData.push('</td>');
                        $myData.push('<td >');$myData.push(ItemData[i].itemname);$myData.push('</td>');
                        $myData.push('<td >');$myData.push(ItemData[i].minorunitname);$myData.push('</td>');
                        $myData.push('<td  >');$myData.push(precise_round(ItemData[i].ReqQty, 5));$myData.push('</td>');
                        $myData.push('<td  >');$myData.push(precise_round(ItemData[i].ApprovedQty, 5));$myData.push('</td>');
                        $myData.push('<td  >');$myData.push(precise_round(ItemData[i].PendingQty, 5));$myData.push('</td>');
                        $myData.push('<td  >');$myData.push( precise_round(ItemData[i].ReceiveQty, 5));$myData.push('</td>');
                        $myData.push('<td  >' );$myData.push( precise_round(ItemData[i].RejectQty, 5));$myData.push('</td>');
                        $myData.push('<td  >' );$myData.push( precise_round(ItemData[i].AblQty, 5));$myData.push('</td>');
                        $myData.push("</tr>");
                    }
                    $myData.push("</table><div>");
                    $myData = $myData.join("");
                    var $newdata = [];
                    $newdata.push('<tr id="ItemDetail'); $newdata.push(id); $newdata.push('"><td></td><td colspan="16">'); $newdata.push($myData); $newdata.push('</td></tr>');
                    $newdata = $newdata.join("");
                    $newdata.insertAfter($(ctrl).closest('tr'));                  
                }
            });
           
        }
        function precise_round(num, decimals) {
            return Math.round(num * Math.pow(10, decimals)) / Math.pow(10, decimals);
        }
        function issueme(ctrl) {
            openmypopup('IndentIssueNew.aspx?IndentNo=' + $(ctrl).closest('tr').attr("id"));
        }
        function setIndentType() {
            $("#<%=ddllocationfrom.ClientID %> option").remove();
            $('#<%=ddlindenttype.ClientID%>').prop('selectedIndex', 0);
            $('#tblitemlist tr').slice(1).remove();
            $('#<%=txtindentno.ClientID%>').val('');
            bindindentfromlocation();
            if ($("#<%=rdoIndentType.ClientID%>").find(":checked").val() == 'PI') {
                //  $('#<%=ddllocationfrom.ClientID%>').prop("disabled", true);
            }
            else {
                // $('#<%=ddllocationfrom.ClientID%>').prop("disabled", false);
            }
        }
        function editData(ctrl) {
            $.fancybox({
                maxWidth: 1500,
                maxHeight: 800,
                fitToView: false,
                width: '100%',
                height: '100%',
                href: 'CreateSalesIndent.aspx?IndentNo=' + $(ctrl).closest('tr').attr("id"),
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                'type': 'iframe'
            });
        }
    </script>    
</asp:Content>

