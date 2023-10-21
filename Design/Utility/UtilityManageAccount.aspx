<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UtilityManageAccount.aspx.cs" Inherits="Design_Utility_UtilityManageAccount" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server"> 

    <link href="../../App_Style/AppStyle.css" rel="stylesheet" type="text/css" />       
     <script type="text/javascript" src="../../Scripts/jquery-3.1.1.min.js"></script>
       <link href="../../App_Style/multiple-select.css" rel="stylesheet"/>              
        <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>
    <script type="text/javascript" src="../../Scripts/Common.js"></script>        
  
    <link href="../../Scripts/JQueryDialog/jquery-ui.css" rel="stylesheet" />
    <script src="../../Scripts/JQueryDialog/jquery-ui.js"></script>
    <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
    <title></title>
</head>
<body>
       <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" /> 
    <form id="form1" runat="server">
         <Ajax:ScriptManager AsyncPostBackErrorMessage="Error..." ID="ScriptManager1" runat="server"> 
     </Ajax:ScriptManager> 
       <div id="Pbody_box_inventory">
            <div class="alert fade" style="position: absolute; left: 30%; border-radius: 15px; z-index: 11111; top: 20%;">
        <p id="msgField" style="color: white; padding: 10px; font-weight: bold;"></p>
    </div>
        <div class="POuter_Box_Inventory">
            <div class="row"  style="text-align: center;">
                <div class="col-md-24">
                <b>Utility Account Manage</b>               
                    </div>
                </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-2"> From Date :</div>
                <div class="col-md-4"><asp:TextBox ID="dtFrom" runat="server"></asp:TextBox>                      
                      <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="dtFrom" PopupButtonID="dtFrom" Format="dd-MMM-yyyy" runat="server">
                                </cc1:CalendarExtender></div>
                <div class="col-md-2">To Date :</div>
                <div class="col-md-4"><asp:TextBox ID="dtTo" runat="server" ></asp:TextBox>                      
                       <cc1:CalendarExtender ID="FromdateCal" TargetControlID="dtTo" PopupButtonID="dtTo" Format="dd-MMM-yyyy" runat="server">
                                </cc1:CalendarExtender></div>
                <div class="col-md-2">Centre :</div>
                <div class="col-md-4"> <asp:ListBox ID="lstCentreAccess"  runat="server" CssClass="multiselect" SelectionMode="Multiple"></asp:ListBox>
                       <asp:HiddenField ID="hdnCentre" runat="server" /></div>
                <div class="col-md-2">Panel :</div>
                <div class="col-md-4"><asp:ListBox ID="ddlPanel" runat="server"   CssClass="multiselect" SelectionMode="Multiple"></asp:ListBox>
                        <asp:HiddenField ID="hdnPanel" runat="server" /></div>
            </div>
            <div class="row">
                <div class="col-md-2"> DiscType:</div>
                <div class="col-md-4"> <asp:DropDownList ID="ddldisc" runat="server" >
                                 <asp:ListItem Value="0">All</asp:ListItem>
                                 <asp:ListItem Value="1">With Disc</asp:ListItem>
                                 <asp:ListItem Value="2">Without Disc</asp:ListItem>
                             </asp:DropDownList></div>
                <div class="col-md-6"></div>
                <div class="col-md-12"> <input id="btnSearch" type="button" value="Search" onclick="Search()"  class="searchbutton" style="width:100px;" "/></div>
                
                </div>           
            </div> 
            <div  id="mydatalist" class="POuter_Box_Inventory" style="display:none">
                <div class="row">
                    <div class="col-md-24">
                     <table>
                       <tr>
                           <td style="width:15%"></td>
                           <td><asp:TextBox ID="txtper" runat="server" Width="100px" MaxLength="2" onkeyup="txtRateVal(this)"  Font-Bold="true" placeholder="Amt in %" ></asp:TextBox>                               
                           </td>
                           <td> <input id="btnadjustamt" type="button" value="Process All" onclick="SaveAdjustAmt()" class="savebutton" style="width:150px;" "/> </td>
                          <td> <input id="btnuntouchable" type="button" value="Un-Touchable Test List" onclick="untouchabletestlist('0')"  class="searchbutton" style="width:150px;" "/> </td>
                             <td> <input id="btnreplacetest" type="button" value="Replaceable Test List" onclick="untouchabletestlist('1')"  class="searchbutton" style="width:150px;" "/> </td>
                           <td style="width:25%"></td>
                           <td><input id="btnupload" type="button" value="Upload Final Data" onclick="finalUploadPopup()"  class="searchbutton" style="width:150px;" "/> </td>
                       </tr>
                   </table></div>
                </div>               
           <div class="content" style=" height: 380px; overflow:scroll;">                   
                    <table class="GridViewStyle" style="width: 99%; border-collapse: collapse" cellspacing="0" rules="all" border="1"  id="tb_ItemList">                        
                        <tr id="header">
                            <td class="GridViewHeaderStyle" style="width:9%">S.No.</td>
                            <td class="GridViewHeaderStyle"style="width:15%">Department</td>
                            <td class="GridViewHeaderStyle" style="width:15%">Total GrossAmount</td>
                            <td class="GridViewHeaderStyle"style="width:15%">Total Discount</td>
                            <td class="GridViewHeaderStyle"style="width:15%">Total NetAmount</td>   
                            <td class="GridViewHeaderStyle"style="width:15%">Reduce Amount</td>  
                             <td class="GridViewHeaderStyle"style="width:15%">#</td>                          
                        </tr>                          
                    </table> 
                              
                </div> 
                 <div class="content">
                   <table>
                       <tr>
                           <td style="width:30%"></td>
                           <td> GrossAmount :<asp:TextBox ID="txtgrossamt" runat="server" Width="100px" ReadOnly="true" Font-Bold="true" BackColor="Pink"></asp:TextBox> </td>
                           <td> Discount :<asp:TextBox ID="txtdisc" runat="server" Width="100px" ReadOnly="true" Font-Bold="true" BackColor="Pink"></asp:TextBox></td>
                           <td> NetAmount :<asp:TextBox ID="txtnetAmt" runat="server" Width="100px" ReadOnly="true" Font-Bold="true" BackColor="Pink"></asp:TextBox></td>
                           <td style="width:10%"></td>
                           <td><input type="button" value="Savedeptwise" class="savebutton" id="btnsavedeptwise" onclick="savedeptwise()" /> </td>
                       </tr>
                   </table>
               </div> 
                </div>  
           <div id="popupdiv" title="Un-Touchable Test Detail" style="display: none;">
                <div class="content">
                    <table>
                        <tr>
                            <td><asp:ListBox ID="lsttouchableTestlist" CssClass="multiselect" SelectionMode="Multiple" Width="200px" runat="server"></asp:ListBox>
                                <asp:HiddenField ID="hdntype" runat="server" />
                            </td>
                            <td><input type="button" id="btnadd" value="AddToList" onclick="AddtoUntouchableList();" /> </td>
                        </tr>
                    </table>
                    </div>
                <div class="content" style="height:300px;overflow:scroll">
                <table style="width:99%;border-collapse:collapse;" id="tbl_untouchable" class="GridViewStyle" >
                    <thead>
                        <tr id="Header">
                          <td class="GridViewHeaderStyle">S.No.</td>
                             <td class="GridViewHeaderStyle">Department</td>  
                            <td class="GridViewHeaderStyle">ItemName</td>  
                            <td class="GridViewHeaderStyle">Remove from list</td>                           
                        </tr>
                    </thead>
                    <tbody></tbody>                   
                </table>
</div>
</div>         
             <div id="popupfinalupload" title="Final Upload Data" style="display: none;">
                <div class="content">
                    <table>
                        <tr>
                            <td>UserName:
                            </td>
                            <td><asp:TextBox ID="txtusername" runat="server" Width="120px"></asp:TextBox> </td>
                        </tr>
                         <tr>
                            <td>Password:
                            </td>
                            <td><asp:TextBox ID="txtpassword" TextMode="Password" runat="server" Width="120px"></asp:TextBox></td>
                        </tr>
                    </table>
                    </div>               
</div> 
           </div>
         </form>
</body>
        <style type="text/css">
        input[type="button"] {
            background-color: maroon; 
            padding: 5px;
            border-radius: 8px;
            -ms-border-radius: 8px;
            text-decoration: none;
            color: white;
            font-weight: bold;
            cursor: pointer;
        }

            input[type="button"]:hover {
                background-color: yellow;
                color: black;
            }
        .auto-style2 {
            width: 125px;
        }
        </style>
        <script type="text/javascript">         
            function popupuntouchabletest(type) {
                var $msge = "Untouchable Test List";
                if (type == "1")
                    $msge="Replaceable Test List"

                $("#popupdiv").dialog({
                    modal: true,
                    autoOpen: false,
                    title: $msge,
                    width: 600,
                    height: 480,
                    buttons: {
                        Close: function () {
                            $(this).dialog('close');
                        },
                        //Save: function () {
                        //    untouchabletest();
                        //    $(this).dialog('close');
                        //}
                    }

                });

                $("#popupdiv").dialog('open');
            }
          
           
            $(function () {
                $('[id*=ddlPanel]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });              
            });
            $(function () {
                $('[id*=lstCentreAccess]').multipleSelect({
                    includeSelectAllOption: true,
                    filter: true, keepOpen: false
                });
            });        

            function Search() {                               
                clear();                          
                if (validation() == false)
                    return;

                serverCall('UtilityManageAccount.aspx/Search', { FromDate: $('#<%=dtFrom.ClientID%>').val(), ToDate: $('#<%=dtTo.ClientID%>').val(), DiscType: $('#<%=ddldisc.ClientID%>').val(), CentreID: $('[id$=lstCentreAccess]').val().toString(), PanelID: $('[id$=ddlPanel]').val().toString() }, function (response) {
                    var $responseData = $.parseJSON(response);                    
                    if ($responseData.status) {
                        $responseData = $responseData.response;
                        if ($responseData.length == 0) {                            
                            showerrormsg("No Data Found");
                            $('#mydatalist').hide();
                            return;
                        }
                        else {
                            var $grossamt = 0;
                            var $disc = 0;
                            var $netamt = 0;
                            for (var i = 0; i < $responseData.length; i++) {
                                $grossamt = parseFloat($grossamt) + parseFloat($responseData[i].GrossAmt);
                                $netamt = parseFloat($netamt) + parseFloat($responseData[i].NetAmount);
                                $disc = parseFloat($disc) + parseFloat($responseData[i].Discount);
                                var $myData = [];
                                $myData.push("<tr style='background-color:White;'>");
                                $myData.push("<td class='GridViewLabItemStyle' style='width:9%'>");
                                $myData.push(parseInt(i + 1));
                                $myData.push("</td>");
                                $myData.push('<td class="GridViewLabItemStyle" style="width:15%;display:none" id="td_subcategoryid">'); $myData.push($responseData[i].SubCategoryID); $myData.push('</td>');
                                $myData.push('<td class="GridViewLabItemStyle" style="width:15%">'); $myData.push($responseData[i].Description); $myData.push('</td>');
                                $myData.push('<td class="GridViewLabItemStyle" style="width:15%">'); $myData.push($responseData[i].GrossAmt); $myData.push('</td>');
                                $myData.push('<td class="GridViewLabItemStyle" style="width:15%">'); $myData.push($responseData[i].Discount); $myData.push('</td>');
                                $myData.push('<td class="GridViewLabItemStyle" style="width:15%" id="td_netamt">'); $myData.push($responseData[i].NetAmount); $myData.push('</td>');
                                $myData.push('<td class="GridViewLabItemStyle" style="width:15%">'); $myData.push('<input type="text" disabled=true style="width:100px" id="txtamt" onkeyup="txtRateVal(this);" />'); $myData.push('</td>');
                                $myData.push('<td class="GridViewLabItemStyle" style="width:15%">'); $myData.push('<input type="checkbox"  id="chk" onchange="enableamt();" />'); $myData.push('</td>');
                                $myData.push("</tr>");
                                $myData = $myData.join("");
                                $('#tb_ItemList').append($myData);
                                $('#mydatalist').show();
                            }
                            $('#<%=txtgrossamt.ClientID%>').val($grossamt);
                            $('#<%=txtdisc.ClientID%>').val($disc);
                            $('#<%=txtnetAmt.ClientID%>').val($netamt);
                        }

                    }
                    else {
                        showerrormsg($responseData.response);                       
                        $('#mydatalist').hide();
                    }
                 });
            }
            function txtRateVal(id) {

                id.value = id.value.replace(/[^0-9]/g, '');
            }
            function getDataadj() {
                var $myData = new Array();              
                            $myData.push({
                                FromDate: $('#<%=dtFrom.ClientID%>').val(),
                                ToDate: $('#<%=dtTo.ClientID%>').val(),
                                DiscType: $('#<%=ddldisc.ClientID%>').val(),
                                AdjustedAmt: $('#<%=txtper.ClientID%>').val(),
                                NetAmount: $('#<%=txtnetAmt.ClientID%>').val(),
                                SubcategoryID: ""
                            });                     
                return $myData;
            }
            function SaveAdjustAmt() {               
                if (validation() == false)
                    return;
                if (Number($('#<%=txtper.ClientID%>').val()) <= 0) {
                    showerrormsg("Adjusted Amt Should be greater than 0");
                    return;
                }
                var $data = getDataadj();
                serverCall('UtilityManageAccount.aspx/SaveAdjustAmt', { data: $data, CentreID: $('[id$=lstCentreAccess]').val().toString(), PanelID: $('[id$=ddlPanel]').val().toString() }, function (response) {
                    var $responseData = $.parseJSON(response);
                    if ($responseData.status) {
                        showmsg($responseData.response);
                        Search();
                    }
                    else {
                        showerrormsg($responseData.response);
                    }
                });
            }
            function untouchabletestlist(type) {
                $('#tbl_untouchable tr').slice(1).remove();
                serverCall('UtilityManageAccount.aspx/untouchabletestlist', { TestType: type }, function (response) {
                    var $responseData = $.parseJSON(response);
                    if ($responseData.status) {                      
                        $responseData = $responseData.response;
                        if ($responseData.length == 0) {
                            showerrormsg("No isReplaceable Test Found");
                            return;
                        }
                        else {
                            for (var i = 0; i < $responseData.length; i++) {
                                var $myData = [];
                                $myData.push("<tr>");
                                $myData.push("<td class='GridViewLabItemStyle' >");
                                $myData.push(parseInt(i + 1));
                                $myData.push("</td>");
                                $myData.push('<td class="GridViewLabItemStyle"><b>'); $myData.push($responseData[i].Description); $myData.push('</b></td>');
                                $myData.push('<td class="GridViewLabItemStyle">'); $myData.push($responseData[i].TypeName); $myData.push('</td>');
                                $myData.push('<td class="GridViewLabItemStyle">'); $myData.push('<img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="UpdateStatus(\'');
                                $myData.push($responseData[i].ItemID); $myData.push("\',"); $myData.push("\'"); $myData.push(type); $myData.push('\')"/>'); $myData.push('</td>');
                                $myData.push("</tr>");
                                $myData = $myData.join("");
                                $('#tbl_untouchable tbody').append($myData);
                            }
                            popupuntouchabletest(type);
                            bindtouchabletestlist(type);
                        }
                    }
                    else {
                        showerrormsg($responseData.response);
                    }
                });
            }
            function UpdateStatus(ItemID, type) {
                serverCall('UtilityManageAccount.aspx/UpdateisReplaceable', { ItemID: ItemID,Type:type }, function (response) {
                    var $responseData = $.parseJSON(response);
                    if ($responseData.status) {
                        showmsg($responseData.response);
                        untouchabletestlist(type);
                    }
                    else {
                        showerrormsg($responseData.response);
                    }
                });
            }
            function AddtoUntouchableList() {
                var $itemID = $('[id$=lsttouchableTestlist]').val().toString();
                serverCall('UtilityManageAccount.aspx/AddtoUntouchableList', { ItemID: $itemID, Type: $('#<%=hdntype.ClientID%>').val() }, function (response) {
                    var $responseData = $.parseJSON(response);
                    if ($responseData.status) {
                        showmsg($responseData.response);
                        untouchabletestlist($('#<%=hdntype.ClientID%>').val());
                    }
                    else {
                        showerrormsg($responseData.response);
                    }
                });
            }
            function bindtouchabletestlist(type) {               

                $('#<%=hdntype.ClientID%>').val('');
                $('#<%=lsttouchableTestlist.ClientID%> option').remove();
                serverCall('UtilityManageAccount.aspx/bindtouchabletestlist', { Type: type }, function (response) {
                    var $responseData = $.parseJSON(response);                                          
                        for (var i = 0; i < $responseData.length; i++) {                           
                            $('#<%=lsttouchableTestlist.ClientID%>').append($("<option></option>").val($responseData[i].ItemID).html($responseData[i].TypeName));                        
                        }
                    $('#<%=hdntype.ClientID%>').val(type);
                    jQuery('#<%=lsttouchableTestlist.ClientID%>').multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                })
            }
            function enableamt() {
                $('#tb_ItemList tr').each(function () {
                    var id = $(this).closest("tr").attr('id');
                    if (id != "header") {
                        if ($(this).closest("tr").find('#chk').prop('checked') == true) {
                            $(this).closest('tr').find('#txtamt').prop('disabled', false);
                            $(this).closest('tr').find('#txtamt').val(0);                           
                        }
                        else {
                            $(this).closest('tr').find('#txtamt').prop('disabled', true);
                            $(this).closest('tr').find('#txtamt').val('');                           
                        }
                    }
                });
            }
            function getData() {
                var $myData = new Array();
                $('#tb_ItemList tr').each(function () {
                    var id = $(this).closest("tr").attr("id");
                    if (id != "header") {
                        if ($(this).closest("tr").find('#chk').is(':checked')) {
                            var $AdjustedAmt = $(this).closest("tr").find("#txtamt").val();
                            if ($AdjustedAmt > 0) {
                                $myData.push({
                                    FromDate: $('#<%=dtFrom.ClientID%>').val(),
                                    ToDate: $('#<%=dtTo.ClientID%>').val(),
                                    DiscType: $('#<%=ddldisc.ClientID%>').val(),
                                    AdjustedAmt: $(this).closest("tr").find("#txtamt").val(),
                                    NetAmount: $(this).closest("tr").find('#td_netamt').html(),
                                    SubcategoryID: $(this).closest("tr").find("#td_subcategoryid").html()
                                });
                            }
                        }
                    }
                });
                return $myData;
            }
            function savedeptwise() {
                if (validation() == false)
                    return;
                var $data = getData();
                if ($data.length == 0) {
                    showerrormsg("please select checkbox and Reduce  amt should be greater than 0");
                    return;
                }
                serverCall('UtilityManageAccount.aspx/SaveAdjustAmt', { data: $data, CentreID: $('[id$=lstCentreAccess]').val().toString(), PanelID: $('[id$=ddlPanel]').val().toString() }, function (response) {
                    var $responseData = $.parseJSON(response);
                    if ($responseData.status) {
                        showmsg($responseData.response);
                        Search();
                    }
                    else {
                        showerrormsg($responseData.response);
                    }
                });
            }
            function validation() {
                var _centre = $('[id$=lstCentreAccess]').val().toString();
                var _panel = $('[id$=ddlPanel]').val().toString();
                if (_centre == "") {
                    showerrormsg("Please select centre");
                    return false;
                }
                if (_panel == "") {
                    showerrormsg("Please select Panel");
                    return false;
                }
                return true;
            }
            function clear() {
                $('#mydatalist').hide();
                $('#tb_ItemList tr').slice(1).remove();
                $('#tbl_untouchable tr').slice(1).remove();
                $('#<%=txtgrossamt.ClientID%>').val('');
                $('#<%=txtdisc.ClientID%>').val('');
                $('#<%=txtnetAmt.ClientID%>').val('');
                $('#<%=hdntype.ClientID%>').val('');
                $('#<%=txtper.ClientID%>').val('');
                $('#<%=txtusername.ClientID%>').val('');
                $('#<%=txtpassword.ClientID%>').val('');
            }
            function showmsg(msg) {
                $('#msgField').html('');
                $('#msgField').append(msg);
                $(".alert").css('background-color', '#04b076');
                $(".alert").removeClass("in").show();
                $(".alert").delay(1500).addClass("in").fadeOut(2000);
            }
            function showerrormsg(msg) {
                $('#msgField').html('');
                $('#msgField').append(msg);
                $(".alert").css('background-color', 'red');
                $(".alert").removeClass("in").show();
                $(".alert").delay(1500).addClass("in").fadeOut(2000);
            }
            function finalUploadPopup() {
                var $msge = "Upload Final Data";

                $("#popupfinalupload").dialog({
                    modal: true,
                    autoOpen: false,
                    title: $msge,
                    width: 300,
                    height: 180,
                    buttons: {
                        Close: function () {
                            $(this).dialog('close');
                        },
                        Save: function () {
                            uploadfinaldata();
                            // $(this).dialog('close');
                        }
                    }

                });

                $("#popupfinalupload").dialog('open');
            }
            function uploadfinaldata() {
                if ($('[id$=txtusername]').val() == "") {
                    showerrormsg('Please enter username');
                    return;
                }
                if ($('[id$=txtpassword]').val() == "") {
                    showerrormsg('Please enter password');
                    return;
                }

                serverCall('UtilityManageAccount.aspx/uploadfinaldata', { UserName: $('[id$=txtusername]').val(), Password: $('[id$=txtpassword]').val() }, function (response) {
                    var $responseData = $.parseJSON(response);
                    if ($responseData.status) {
                        showmsg($responseData.response);
                        $("#popupfinalupload").dialog('close');
                    }
                    else {
                        showerrormsg($responseData.response);                      
                    }
                });
            }
        </script>
   
</html>
