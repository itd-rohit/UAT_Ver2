<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="~/Design/Quality/ILCScheduleRequestNew.aspx.cs" Inherits="Design_Quality_ILCScheduleRequest" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <style type="text/css">
        /*.ajax__calendar_container .ajax__calendar_other .ajax__calendar_day,
        .ajax__calendar_container .ajax__calendar_other .ajax__calendar_year,
        .ajax__calendar_next, .ajax__calendar_prev, .ajax__calendar_title {
            display: none;
        }*/
    </style>
    
    
     <link href="../../App_Style/multiple-select.css" rel="stylesheet" />


    <script type="text/javascript" src="../../Scripts/jquery.multiple.select.js"></script>



    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory">
            <div class="row" style="text-align: center">
                <div class="col-md-24">
                    <b>EQAS Schedule Request</b>

                </div>
            </div>
        </div>

        <div class="POuter_Box_Inventory">
             <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Schedule Type </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-21">
                    <asp:RadioButtonList ID="rd" runat="server" RepeatDirection="Horizontal">
                        <asp:ListItem Value="3" Selected="True">EQAS Registration</asp:ListItem>
                    </asp:RadioButtonList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Processing Lab </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlprocessinglab" onchange="GetAllProgram()" class="ddlprocessinglab chosen-select chosen-container" runat="server"></asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Program </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlprogram"  class="ddlprocessinglab chosen-select chosen-container" onchange="GetMonth()" runat="server"></asp:DropDownList>
                </div>

            </div>
             <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Year </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                        <asp:DropDownList ID="txtcurrentyear" runat="server" onchange="GetMonth()"  ></asp:DropDownList>
                    </div>
                  <div class="col-md-3">
                    <label class="pull-left">Remarks </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtreason" runat="server" MaxLength="200" CssClass="requiredField"></asp:TextBox>
                </div>
            </div>
             <div class="row" id="divMonth">
                    <table id="tblMonth" style="width: 70%; border-collapse: collapse; text-align: left;">
                          <tr id="trMonthHeader">
                            <td class="GridViewHeaderStyle">ID</td>
                            <td class="GridViewHeaderStyle">MonthName</td>
                            <td class="GridViewHeaderStyle">From Date</td>
                            <td class="GridViewHeaderStyle">To Date</td>
                            <td class="GridViewHeaderStyle">Active</td>
                        </tr>
                        </table>
             </div>
            <div class="row" style="display:none;">
                <div class="col-md-3">
                    <label class="pull-left">From Day </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txtfromdate" runat="server"></asp:TextBox>

                    <cc1:CalendarExtender ID="calFromDate" runat="server" TargetControlID="txtfromdate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                </div> <div class="col-md-1"></div>
                <div class="col-md-2">
                    <label class="pull-left">To Day </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-2">
                    <asp:TextBox ID="txttodate" runat="server"></asp:TextBox>

                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txttodate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                </div>

            </div>

            <div class="row">
               
                 </div>
               <div class="row">

                   <div class="col-md-10">
                       </div>
                   <div class="col-md-12">
                        <% if (approvaltypemaker == "1")
                               { %>

                            <input type="button" value="Save" class="savebutton" onclick="saveme()" />

                            <% }
                               else
                               { 
                               
                            %>

                            <span style="font-weight: bold; color: red; font-style: initial">You can't make request.Contact to admin for maker right</span>
                            <%} %>

                            <input type="button" style="display:none;" value="Reset" class="resetbutton" onclick="resetForm()" />
                        </div>
                 </div>
              <div class="row" style="display:none;">
                   <div class="col-md-4"></div>
                <div class="col-md-2" style="width: 15px; height: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: lightyellow; cursor: pointer;"
                                        onclick="searchmewithcolor('lightsalmon');">
                </div>
                <div class="col-md-3">Request Send</div>

                   <div class="col-md-2" style="width: 15px; height: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: pink; cursor: pointer;"
                                        onclick="searchmewithcolor('bisque');">
                </div>
                <div class="col-md-3">Request Checked</div>
                <div class="col-md-2" style="width: 15px; height: 15px; border-right: black thin solid; border-top: black thin solid; border-left: black thin solid; border-bottom: black thin solid; background-color: lightgreen; cursor: pointer;"
                                        onclick="searchmewithcolor('white');">
                </div>
                <div class="col-md-3">Request Approved</div>                                             
            </div>
       
</div>
        <div class="POuter_Box_Inventory" style="display:none;" >
            <div class="row">

                <div class="TestDetail" style="margin-top: 5px; max-height: 360px; overflow: auto; width: 100%;">
                    <table id="tbl" style="width: 99%; border-collapse: collapse; text-align: left;">

                        <tr id="trheader">
                            <td class="GridViewHeaderStyle" style="width: 50px;">S.No.</td>
                            <td class="GridViewHeaderStyle" style="width: 20px;">#</td>
                            <td class="GridViewHeaderStyle" style="width: 50px;">Action</td>
                            <td class="GridViewHeaderStyle">Lab Code</td>
                            <td class="GridViewHeaderStyle">Processing Lab</td>
                            <td class="GridViewHeaderStyle">Schedule Type</td>
                            <td class="GridViewHeaderStyle">From Date</td>
                            <td class="GridViewHeaderStyle">To Date</td>
                            <td class="GridViewHeaderStyle">Reason</td>
                            <td class="GridViewHeaderStyle">Status</td>
                            <td class="GridViewHeaderStyle">Entry Date</td>
                            <td class="GridViewHeaderStyle">Entry By</td>
                            <td class="GridViewHeaderStyle">Check Date</td>
                            <td class="GridViewHeaderStyle">Check By</td>
                            <td class="GridViewHeaderStyle">Approve Date</td>
                            <td class="GridViewHeaderStyle">Approve By</td>

                        </tr>
                    </table>
                </div>
            </div>

        </div>

    </div>


    <asp:Panel ID="panelemp" runat="server" Style="display: none;">
        <div class="POuter_Box_Inventory" style="background-color: papayawhip">
            <div class="Purchaseheader">ILC Schedule Request</div>
            <div class="row">
                <div class="col-md-5">
                    <label class="pull-left">From Date </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtfromdate1" runat="server"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtfromdate1" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
</div>
                 <div class="col-md-5">
                    <label class="pull-left">To Date </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                     <asp:TextBox ID="txttodate1" runat="server" ></asp:TextBox>

                        <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txttodate1" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                </div></div>

              <div class="row">
                <div class="col-md-5">
                    <label class="pull-left">Remarks</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-18">
                    <asp:TextBox ID="txtremarks" runat="server"  MaxLength="200" CssClass="requiredField"></asp:TextBox>

                    </div>
                  </div>

             <div class="row" style="text-align:center">
                  <input type="text" id="txtid" style="display: none;" />
                        <input type="button" value="Check" onclick="checkmenow()" class="savebutton" style="display: none;" id="btncheck" />
                        <input type="button" value="Approve" onclick="approvemenow()" class="savebutton" style="display: none;" id="btnapprove" />&nbsp;&nbsp;
                       <asp:Button ID="btnclose" runat="server" CssClass="resetbutton" Text="Close" />
                 </div>
            
        </div>

    </asp:Panel>
    <cc1:ModalPopupExtender ID="modelpopupemp" runat="server" TargetControlID="Button1" CancelControlID="btnclose"
        BackgroundCssClass="filterPupupBackground" PopupControlID="panelemp">
    </cc1:ModalPopupExtender>

    <asp:Button ID="Button1" runat="server" Style="display: none;" />

    <script type="text/javascript">
        var approvaltypemaker = '<%=approvaltypemaker %>';
        var approvaltypechecker = '<%=approvaltypechecker %>';
        var approvaltypeapproval = '<%=approvaltypeapproval %>';

        $(function () {
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
            bindcentre();
            // GetAllDate();
        });

        function bindcentre() {
            serverCall('ILCScheduleRequestNew.aspx/bindCentre', {}, function (response) {
                jQuery("#<%=ddlprocessinglab.ClientID%>").bindDropDown({ defaultValue: 'Select Processing Lab', data: JSON.parse(response), valueField: 'centreid', textField: 'centre', isSearchAble: true });                                       
             });           
             }      
    </script>


    <script type="text/javascript">
        function saveme() {
            var centreid = $('#<%=ddlprocessinglab.ClientID%>').val();
            if (centreid == "0") {
                toast("Error","Please Select Processing Lab");
                return;
            }
            var programid = $('#<%=ddlprogram.ClientID%>').val();
            if (programid == "0") {
                toast("Error", "Please Select Program");
                return;
            }
            var isvalid = 1;
            var $objMontDetail = new Array();
            $("#tblMonth tr").each(function () {
                if ($(this).closest("tr").attr("id") != "trMonthHeader") {
                    if (Number($(this).find("#ddlFromDate").val()) > Number($(this).find("#ddltoDate").val())) {
                        isvalid = 0;
                    }
                    $objMontDetail.push({
                        MonthID: $(this).closest("tr").find('#tdMonthID').text(),
                        MonthName: $(this).closest("tr").find('#tdMonthName').text(),
                        FromDate: $(this).find("#ddlFromDate").val(),
                        ToDate: $(this).find("#ddltoDate").val(),
                        IsActive: $(this).find("#chkIsActive").is(':checked') == true ? 1 : 0
                    });
                }
            });
            if (isvalid == 0) {
                toast("Error", "FromDate Can't Greater Than ToDate");
                return;
            }
            var YearID = $('#<%=txtcurrentyear.ClientID%>').val();
            var reason = $('#<%=txtreason.ClientID%>').val();
            if (reason == "") {
                toast("Error","Please Enter Remarks");
                $('#<%=txtreason.ClientID%>').focus();
                return;
            }

            serverCall('ILCScheduleRequestNew.aspx/SaveData', { centreid: centreid, ProgramID: programid, YearID: YearID, MontDetail: $objMontDetail, reason: reason }, function (response) {
                var save = response;
                if (save == "1") {
                    toast("Success", "Record Saved Successfully");
                    GetAllDate();
                    clearForm();
                }
                else {
                    toast("Error", save);
                }
            });                      
        }
        function clearForm() {
            $('#<%=txtreason.ClientID%>').val('');
            //jQuery('#<%=ddlprocessinglab.ClientID%> option').prop('selectedIndex', 0).trigger('chosen:updated');
            //$('#<%=rd.ClientID %>').find("input[value='1']").prop("checked", true);
        }
        function resetForm() {
            $('#<%=txtreason.ClientID%>').val('');
            jQuery('#<%=ddlprocessinglab.ClientID%> option').prop('selectedIndex', 0).trigger('chosen:updated');
            $('#<%=rd.ClientID %>').find("input[value='1']").prop("checked", true);
        }
        function GetAllProgram() {
            if ($('#<%=ddlprocessinglab.ClientID%>').val() == "0") {
                return;
            }
            serverCall('ILCScheduleRequestNew.aspx/GetAllProgram', { centreid: $('#<%=ddlprocessinglab.ClientID%>').val() }, function (response) {
                jQuery("#<%=ddlprogram.ClientID%>").bindDropDown({ defaultValue: 'Select Program', data: JSON.parse(response), valueField: 'ProgramID', textField: 'ProgramName', isSearchAble: true });
            });
        }
        function GetMonth() {
            var centreid = $('#<%=ddlprocessinglab.ClientID%>').val();
            if (centreid == "0") {
                toast("Error", "Please Select Processing Lab");
                return;
            }
            var programid = $('#<%=ddlprogram.ClientID%>').val();
            if (programid == "0") {
                toast("Error", "Please Select Program");
                return;
            }
            var YearID = $('#<%=txtcurrentyear.ClientID%>').val();
            serverCall('ILCScheduleRequestNew.aspx/GetMonth', { centreid: centreid, ProgramID: programid, YearID: YearID }, function (response) {
                ItemData = $.parseJSON(response);
                if (ItemData.length === 0) {
                    return;
                }
                $('#tblMonth tr').slice(1).remove();
                $('#<%=txtreason.ClientID%>').val(ItemData[0].Remarks);
                for (i = 0; i < ItemData.length; i++) {
                    var $mydata = [];
                    $mydata.push("<tr>");
                    $mydata.push('<td class="GridViewLabItemStyle" id="tdMonthID">'); $mydata.push(ItemData[i].MonthID); $mydata.push('</td>');
                    $mydata.push('<td class="GridViewLabItemStyle" id="tdMonthName">'); $mydata.push(ItemData[i].MonthName); $mydata.push('</td>');
                    $mydata.push('<td class="GridViewLabItemStyle">');
                    $mydata.push('<select id="ddlFromDate">');
                    var MonthCount = parseInt(ItemData[i].MonthDays);
                    for (j = 1; j <= MonthCount; j++) {
                        if (ItemData[i].SelectedMonthFromDay == j) {
                            $mydata.push('<option selected="selected" value=' + j + '>' + j + '</option>');
                        }
                        else {
                            $mydata.push('<option value=' + j + '>' + j + '</option>');
                        }
                    }
                    $mydata.push('</select>');
                    $mydata.push('</td>');
                    $mydata.push('<td class="GridViewLabItemStyle">');
                    $mydata.push('<select id="ddltoDate">');
                    var MonthCount = parseInt(ItemData[i].MonthDays);
                    for (j = 1; j <= MonthCount; j++) {
                        if (ItemData[i].SelectedMonthToDay == j) {
                            $mydata.push('<option selected="selected" value=' + j + '>' + j + '</option>');
                        }
                        else {
                            $mydata.push('<option value=' + j + '>' + j + '</option>');
                        }
                    }
                    $mydata.push('</select>');
                    $mydata.push('</td>');
                    $mydata.push('<td class="GridViewLabItemStyle">');
                    if (ItemData[i].IsActive == 1) {
                        $mydata.push('<input type="checkbox" checked="checked" id="chkIsActive"> ');
                    }
                    else {
                        $mydata.push('<input type="checkbox" id="chkIsActive"> ');
                    }
                    $mydata.push('</td>');
                    $mydata.push("</tr>");
                    $mydata = $mydata.join("");
                    $('#tblMonth').append($mydata);
                }
            });

        }
        function GetAllDate() {
            if ($('#<%=ddlprocessinglab.ClientID%>').val() == "0") {
                $('#tbl tr').slice(1).remove();
                return;
            }         
            $('#tbl tr').slice(1).remove();
            serverCall('ILCScheduleRequestNew.aspx/GetAllDate', { centreid: $('#<%=ddlprocessinglab.ClientID%>').val() }, function (response) {
                ItemData = $.parseJSON(response);
                if (ItemData.length === 0) {
                    
                    return;
                }

                for (i = 0; i < ItemData.length; i++) {
                    var $mydata = [];
                    $mydata.push("<tr style='background-color:");$mydata.push(ItemData[i].RowColor);$mydata.push(";' id='");$mydata.push(ItemData[i].id);$mydata.push("'>");
                    $mydata.push('<td class="GridViewLabItemStyle">');$mydata.push(parseInt(i + 1));$mydata.push('</td>');
                    $mydata.push('<td class="GridViewLabItemStyle">');
                    if (ItemData[i].ApprovalStatus == "Request Send") {
                        $mydata.push('<img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow(this)"/>');
                    }
                    else if (ItemData[i].ApprovalStatus == "Request Checked") {
                        $mydata.push('<img src="../../App_Images/Delete.gif" style="cursor:pointer;" onclick="deleterow(this)"/>');
                    }
                    $mydata.push('</td>');
                    $mydata.push('<td class="GridViewLabItemStyle">');
                    if (ItemData[i].ApprovalStatus == "Request Send" && approvaltypechecker=="1") {

                        $mydata.push('<input type="button" value="Check" onclick="checkme(this)" style="cursor:pointer;font-weight:bold;" />');
                    }
                    else if (ItemData[i].ApprovalStatus == "Request Checked" && approvaltypeapproval == "1") {
                        $mydata.push('<input type="button" value="Approve" onclick="approveme(this)" style="cursor:pointer;font-weight:bold;" />');
                    }                     
                    $mydata.push('</td>');
                    $mydata.push('<td class="GridViewLabItemStyle">');$mydata.push(ItemData[i].CentreCode);$mydata.push('</td>');
                    $mydata.push('<td class="GridViewLabItemStyle" style="font-weight:bold;">');$mydata.push(ItemData[i].Centre);$mydata.push('</td>');
                    $mydata.push('<td class="GridViewLabItemStyle" style="font-weight:bold;">');$mydata.push(ItemData[i].ScheduleType);$mydata.push('</td>');
                    $mydata.push('<td class="GridViewLabItemStyle" style="font-weight:bold;" id="txtfromdate">');$mydata.push(ItemData[i].fromdate);$mydata.push('</td>');
                    $mydata.push('<td class="GridViewLabItemStyle" style="font-weight:bold;" id="txttodate">');$mydata.push(ItemData[i].todate);$mydata.push('</td>');
                    $mydata.push('<td class="GridViewLabItemStyle" style="font-weight:bold;" id="txtremarks">');$mydata.push(ItemData[i].Remarks);$mydata.push('</td>');
                    $mydata.push('<td class="GridViewLabItemStyle" style="font-weight:bold;">');$mydata.push(ItemData[i].ApprovalStatus);$mydata.push('</td>');
                    $mydata.push('<td class="GridViewLabItemStyle">');$mydata.push(ItemData[i].EntryDate);$mydata.push('</td>');
                    $mydata.push('<td class="GridViewLabItemStyle">');$mydata.push(ItemData[i].entryby);$mydata.push('</td>');                      
                    $mydata.push('<td class="GridViewLabItemStyle">');$mydata.push(ItemData[i].CheckDate);$mydata.push('</td>');
                    $mydata.push('<td class="GridViewLabItemStyle">');$mydata.push(ItemData[i].CheckByName);$mydata.push('</td>');
                    $mydata.push('<td class="GridViewLabItemStyle">');$mydata.push(ItemData[i].ApproveDate);$mydata.push('</td>');
                    $mydata.push('<td class="GridViewLabItemStyle">');$mydata.push(ItemData[i].ApproveByName);$mydata.push('</td>');
                    $mydata.push("</tr>");
                    $mydata = $mydata.join("");
                    $('#tbl').append($mydata);
                }

            });
            
            }



        function deleterow(itemid) {
            if (confirm("Do You Want To Cancel This Request?")) {
                var id = $(itemid).closest('tr').attr('id');
                serverCall('ILCScheduleRequestNew.aspx/deletedata', { id: id }, function (response) {
                    if (response == "1") {
                        toast("Success","Data Deleted..");
                        var table = document.getElementById('tbl');
                        table.deleteRow(itemid.parentNode.parentNode.rowIndex);
                    }
                    else {
                        toast("Error","Some Error ..");
                    }
                });              
            }
        }
        function checkme(ctrl) {         
            $('#txtid').val($(ctrl).closest('tr').attr('id'));
            $('#<%=txtfromdate1.ClientID%>').val($(ctrl).closest('tr').find('#txtfromdate').html());
            $('#<%=txttodate1.ClientID%>').val($(ctrl).closest('tr').find('#txttodate').html());
            $('#<%=txtremarks.ClientID%>').val($(ctrl).closest('tr').find('#txtremarks').html());
            $('#btncheck').show();
            $('#btnapprove').hide();
            $find("<%=modelpopupemp.ClientID%>").show();
        }
        function approveme(ctrl) {
            $('#txtid').val($(ctrl).closest('tr').attr('id'));
            $('#<%=txtfromdate1.ClientID%>').val($(ctrl).closest('tr').find('#txtfromdate').html());
            $('#<%=txttodate1.ClientID%>').val($(ctrl).closest('tr').find('#txttodate').html());
            $('#<%=txtremarks.ClientID%>').val($(ctrl).closest('tr').find('#txtremarks').html());
            $('#btncheck').hide();
            $('#btnapprove').show();
            $find("<%=modelpopupemp.ClientID%>").show();
        }
        function checkmenow() {
            if ($('#<%=txtremarks.ClientID%>').val() == "") {
                $('#<%=txtremarks.ClientID%>').focus();
                toast("Error","Please Enter Remarks");
                return;
            }
            serverCall('ILCScheduleRequestNew.aspx/checkme', { id: $('#txtid').val(), fromdate: $('#<%=txtfromdate1.ClientID%>').val(), todate: $('#<%=txttodate1.ClientID%>').val(), reason: $('#<%=txtremarks.ClientID%>').val() }, function (response) {
                if (response == "1") {
                    toast("Success","ILC Schedule Request Checked..");
                    GetAllDate();
                    $find("<%=modelpopupemp.ClientID%>").hide();
                }
                else {
                    toast("Error","Some Error ..");
                }
            });
            
            }


        function approvemenow() {

            if ($('#<%=txtremarks.ClientID%>').val() == "") {
                $('#<%=txtremarks.ClientID%>').focus();
                toast("Error","Please Enter Remarks");
                return;
            }

            serverCall('ILCScheduleRequestNew.aspx/approveme', { id: $('#txtid').val(), fromdate: $('#<%=txtfromdate1.ClientID%>').val(), todate: $('#<%=txttodate1.ClientID%>').val(), reason: $('#<%=txtremarks.ClientID%>').val() }, function (response) {
                if (response == "1") {
                    toast("Success","ILC Schedule Request Approve..");
                    GetAllDate();
                    $find("<%=modelpopupemp.ClientID%>").hide();

                }
                else {
                    toast("Error","Some Error ..");
                }
            });          
        }

         
    </script>
</asp:Content>

