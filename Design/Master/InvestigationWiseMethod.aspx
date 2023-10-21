<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="InvestigationWiseMethod.aspx.cs" Inherits="Design_Master_InvestigationWiseMethod" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/jquery-ui.css" />
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />

    <%: Scripts.Render("~/bundles/JQueryUIJs") %>
    <%: Scripts.Render("~/bundles/MsAjaxJs") %>
    <%: Scripts.Render("~/bundles/Chosen") %>
    <script type="text/javascript" src="../../Scripts/tableHeadFixer.js"></script>
    <style type="text/css">
        .selected {
            background-color: aqua !important;
            border: 2px solid black;
        }
    </style>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Investigation Centre Machine Wise Method</b>
            <span id="spnError"></span>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div id="PatientDetails">
                <div class="row" style="margin-top: 0px;">
                    <div class="col-md-21">
                        <div class="row">
                            <div class="col-md-3 ">
                                <label class="pull-left">Centre   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3 ">
                                <asp:DropDownList ID="ddlcentretype" runat="server" ClientIDMode="Static" class="ddlcentretype  chosen-select chosen-container" onchange="$bindcentre()">
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-5">
                                <asp:ListBox ID="ddlcentre" runat="server" ClientIDMode="Static" class="ddlcentre  chosen-select chosen-container" onchange="$searchitem()"></asp:ListBox>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">Department   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8">
                                <asp:DropDownList ID="ddldepartment" ClientIDMode="Static" runat="server" class="ddldepartment chosen-select chosen-container" onchange="$binditem()" />
                            </div>
                        </div>
                        <div class="row">
                            
                            <div class="col-md-3">
                                <label class="pull-left">Investigation   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8">
                                <asp:DropDownList ID="ddlinvestigation" ClientIDMode="Static" runat="server" class="ddlinvestigation chosen-select chosen-container" onchange="$searchitem()">
                                </asp:DropDownList>
                            </div>
                             <div class="col-md-3">
                                <label class="pull-left">Machine   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8">
                                <asp:DropDownList ID="ddlmachine" runat="server" ClientIDMode="Static" class="ddlmachine chosen-select chosen-container" onchange="$searchitem()">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="row">
                           
                            <div class="col-md-3" style="display:none;">
                                <label class="pull-left">Method   </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-8" style="display:none;">
                                <asp:TextBox ID="txtmethod" runat="server" placeholder="Enter Method" MaxLength="100" ></asp:TextBox>
                            </div>
                        </div>
                        <div class="row" style="text-align: center">
                            <input type="button" value="Search" class="searchbutton" onclick="$searchitem()" />
                            <input type="button" value="Save" class="savebutton" onclick="saveme()" />
                            <input type="button" value="Export To Excel" class="searchbutton" onclick="getdataexcel()" />
                        </div>

                    </div>
                </div>
            </div>
        </div>
         <div class="POuter_Box_Inventory">
            <div class="row" style="height: 160px; overflow-y: auto; overflow-x: auto;">
                 <div class="col-md-3">
                     <asp:CheckBox ID="chkAll" ClientIDMode="Static" runat="server" Text="ALL" onclick="checkAll(this)" /><br/>
                      <asp:CheckBox ID="chkDefaultAll" runat="server" Text="Default Check" ClientIDMode="Static" onclick="checkDefaultAll(this)" Checked="true" />
                </div>
                <div class="col-md-21">
                     <div style="overflow: scroll; height: 150px;text-align: left; border: solid 1px">
                            <asp:CheckBoxList ID="chlfield" CssClass="chkColumnsDetail" ClientIDMode="Static" runat="server" RepeatColumns="5" RepeatDirection="Horizontal">
                            </asp:CheckBoxList>
                        </div>
                </div>
           </div>
             </div>
        <div class="POuter_Box_Inventory">
            <div class="row" style="height: 360px; overflow-y: auto; overflow-x: auto;">
                <div class="col-md-24">
                    <table style="width: 99%; border-collapse: collapse;" id="tb_ItemList" class="GridViewStyle">

                        <tr id="triteheader">
                            <th class="GridViewHeaderStyle" style="width: 20px;"># </th>
                            <th class="GridViewHeaderStyle" style="width: 300px;">Centre </th>
                            <th class="GridViewHeaderStyle" style="width: 150px;">Department </th>
                            <th class="GridViewHeaderStyle" style="width: 95px;">Test Code </th>
                            <th class="GridViewHeaderStyle" style="width: 300px;">Test Name </th>
                            <th class="GridViewHeaderStyle" style="width: 100px;">SampleType </th>
                            <th class="GridViewHeaderStyle" style="width: 100px;">Container </th>
                            <th class="GridViewHeaderStyle" style="width: 100px;">ColorName </th>
                            <th class="GridViewHeaderStyle" style="width: 300px;">Machine </th>
                          <%--  <th class="GridViewHeaderStyle" style="width: 250px;">Method </th>--%>
                            <th class="GridViewHeaderStyle" style="width: 300px;">Bookingcutoff </th>
                            <th class="GridViewHeaderStyle" style="width: 300px;">SRAcutoff </th>
                            <th class="GridViewHeaderStyle" style="width: 300px;">Reportingcutoff </th>
                            <th class="GridViewHeaderStyle" style="width: 300px;">Testprocessingday_DayType </th>
                            <th class="GridViewHeaderStyle" style="width: 300px;">Processingdays </th>
                            <th class="GridViewHeaderStyle" style="width: 300px;">ReportDeliverydays </th>
                            <th class="GridViewHeaderStyle" style="width: 300px;">TotalTATAfterBookingCutoff </th>
                            <th class="GridViewHeaderStyle" style="width: 300px;">TotalTATAfterSRACutoff </th>
                            <th class="GridViewHeaderStyle" style="width: 300px;">Last_TAT_modified_Date </th>
                            <th class="GridViewHeaderStyle" style="width: 300px;">Last_TAT_modified_by </th>

                            <th class="GridViewHeaderStyle" style="width: 30px;">Edit</th>

                        </tr>

                    </table>
                </div>

            </div>
        </div>

    </div>

    <script type="text/javascript">

        $(document).ready(function () {
            $binditem();
            $('.chkColumnsDetail input[type="checkbox"]').each(function () {
                $(this).parent().addClass('chk');
                if ($(this).val().split('#')[1] == "1")
                    $(this).parent().addClass('chk chkDefault');
                else
                    $(this).parent().addClass('chk');

            });

        });

        var $binditem = function () {
            var $ddlPanel = $('#ddlinvestigation');
            serverCall('InvestigationWiseMethod.aspx/GetTestMaster', { department: jQuery("#ddldepartment").val() }, function (response) {
                $ddlPanel.bindDropDown({ data: JSON.parse(response), valueField: 'investigation_id', textField: 'invname', defaultValue: "", isSearchAble: true });

            });
        }




        function saveme() {

            if (jQuery('#ddlinvestigation').val() == "0") {
                toast("Error", "Please Select Investigation", "");
                return;
            }

            if (jQuery('#ddlcentre').val() == "0") {
                toast("Error", "Please Select Centre", "");
                return;
            }

            var centreid = jQuery('#ddlcentre').val();
            if (centreid == "") {
                toast("Error", "Please Select Centre", "");
                return;
            }

            if ($('#ddlmachine').val() == "0") {
                toast("Error", "Please Select Machine", "");
                return;
            }

          //  if ($('#<%=txtmethod.ClientID%> ').val() == "") {
             //   toast("Error", "Please Enter Method", "");
             //   return;
            //   }
            //method: $('#<%=txtmethod.ClientID%> ').val() 
            serverCall('InvestigationWiseMethod.aspx/savedata', { investigationid: $('#ddlinvestigation').val(), centreid: centreid, machine: $('#ddlmachine').val()}, function (response) {
                $responseData = $.parseJSON(response);
                if ($responseData.status) {
                    if ($responseData.response == 1) {
                        toast("Info", " Method Saved.!", "");
                        $searchitem();
                    }
                    else {
                        toast("Error", $responseData.response, "");
                        return;
                    }
                }
                else {
                    toast("Error", $responseData.response, "");
                    return;
                }

            });

        }

        function $searchitem() {
            $('#tb_ItemList tr').slice(1).remove();
            serverCall('InvestigationWiseMethod.aspx/searchdata', { investigationid: $('#ddlinvestigation').val(), centreid: $('#ddlcentre').val(), machine: $('#ddlmachine').val(), departmentid: $('#ddldepartment').val() }, function (response) {
                        $responseData = $.parseJSON(response);
                        if ($responseData.status) {
                            $responseData = $responseData.response;
                            if ($responseData.length == 0) {
                                toast("Info", "No Data Found", "");
                            }
                            else {

                                ItemData = $responseData;
                                for (var i = 0; i <= ItemData.length - 1; i++) {
                                    var $myData = [];
                                    $myData.push("<tr style='background-color:lightgreen;height:20px;' id='");
                                    $myData.push(ItemData[i].id);
                                    $myData.push("'>");
                                    $myData.push('<td class="GridViewLabItemStyle" >');
                                    $myData.push(parseInt(i + 1)); $myData.push('</td>');
                                    $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].centre); $myData.push('</td>');
                                    $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].deptname); $myData.push('</td>');
                                    $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].TestCode); $myData.push('</td>');
                                    $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].TestName); $myData.push('</td>');
                                    $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].SampleTypename); $myData.push('</td>');
                                    $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].Container); $myData.push('</td>');
                                    $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].ColorName); $myData.push('</td>');
                                    $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].MachineName); $myData.push('</td>');
                                    //$myData.push('<td class="GridViewLabItemStyle" ><span class="edit" id="spanmethod">'); $myData.push(ItemData[i].method);
                                    //$myData.push('</span><input type="text" id="txtmethod" class="edit" style="width:100px;display:none;" value="'); $myData.push(ItemData[i].method);
                                    //$myData.push('"/>&nbsp;<input class="edit" type="button" value="Update" style="cursor:pointer;font-weight:bold;display:none;" onclick="editme(this)"/>&nbsp;<img src="../../App_Images/Delete.gif" style="cursor:pointer;display:none;" class="edit" onclick="deleteme(this)"/> </td>');



                                    $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].bookingcutoff); $myData.push('</td>');
                                    $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].sracutoff); $myData.push('</td>');
                                    $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].reportingcutoff); $myData.push('</td>');
                                    $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].Testprocessingday_DayType); $myData.push('</td>');
                                    $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].Processingdays); $myData.push('</td>');
                                    $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].ReportDeliverydays); $myData.push('</td>');
                                    $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].TotalTATAfterBookingCutoff); $myData.push('</td>');
                                    $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].TotalTATAfterSRACutoff); $myData.push('</td>');
                                    $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].Last_TAT_modified_Date); $myData.push('</td>');
                                    $myData.push('<td class="GridViewLabItemStyle" >'); $myData.push(ItemData[i].Last_TAT_modified_by); $myData.push('</td>');

                                    $myData.push('<td class="GridViewLabItemStyle"  ><img src="../../App_Images/folder.GIF" style="cursor:pointer;" onclick="editme1(this)" /></td>');

                                    $myData.push('</tr>');
                                    $myData = $myData.join("");
                                    jQuery('#tb_ItemList').append($myData);

                                }
                                //jQuery("#tb_ItemList").tableHeadFixer({
                                //});

                            }

                        }
                        else {
                            toast("Error", $responseData.response, "");
                            return;
                        }
                    });

        }
       
      

        function checkAll(rowId) {
            if ($(rowId).is(':checked')) {
                $("#chkDefaultAll").prop('checked', false);
                $(".chk input[type=checkbox]").prop('checked', 'checked');
            }
            else {
                $("#chkDefaultAll [type=checkbox]").prop('checked', 'checked');
                $(".chk [type=checkbox]").prop('checked', false);
                $(".chkDefault input[type=checkbox],#chkDefaultAll").prop('checked', 'checked');
            }
        }

        function checkDefaultAll(rowId) {
            if ($(rowId).is(':checked')) {
                $("#chkAll").prop('checked', false);
                $(".chk [type=checkbox]").prop('checked', false);
                $(".chkDefault input[type=checkbox]").prop('checked', 'checked');
            }
            else {
                $(".chk [type=checkbox]").prop('checked', false);
                $("#chkAll").prop('checked', 'checked');
                $(".chk input[type=checkbox]").prop('checked', 'checked');
                // $(".chkDefault [type=checkbox]").prop('checked', false);
            }
        }


        function editme1(ctrl) {

                    $(ctrl).closest('tr').find(".edit").slideToggle("slow");

                    $("#tblitemlist tr").removeClass("selected");

                    $(ctrl).closest('tr').addClass("selected");
                }
                function editme(ctrl) {

                    var id = $(ctrl).closest('tr').attr('id');
                    var method = $(ctrl).closest('tr').find('#txtmethod').val();
                    if (method == "") {
                        toast("Error", "Please Enter Method", "");
                        $(ctrl).closest('tr').find('#txtmethod').focus();
                        return;
                    }
                    serverCall('InvestigationWiseMethod.aspx/editdata', { id: id, method: method }, function (response) {
                        $responseData = $.parseJSON(response);
                        if ($responseData.status) {
                            if ($responseData.response == 1) {
                                toast("Info", "Method Updated.!", "");
                                $searchitem();
                            }
                            else {
                                toast("Error", $responseData.response, "");
                                return;
                            }
                        }
                        else {
                            toast("Error", $responseData.response, "");
                            return;
                        }
                    });
                }

                function deleteme(ctrl) {
                    var id = $(ctrl).closest('tr').attr('id');
                    if (confirm("Do You Want To Delete?")) {
                        serverCall('InvestigationWiseMethod.aspx/deletedata', { id: id }, function (response) {
                            $responseData = $.parseJSON(response);
                            if ($responseData.status) {
                                if ($responseData.response == 1) {
                                    toast("Info", "Data Deleted.!", "");
                                    $searchitem();
                                }
                                else {
                                    toast("Error", $responseData.response, "");
                                    return;
                                }
                            }
                            else {
                                toast("Error", $responseData.response, "");
                                return;
                            }

                        });
                    }
                }
                function getFieldlist() {
                    var fldList="";
                    $("[id*=chlfield] input:checked").each(function () {
                        fldList = fldList == "" ? $(this).val().split('#')[0] : fldList + "," + $(this).val().split('#')[0];
                    });
                    return (fldList);
                }

                function getdataexcel() {
                    var FldList = getFieldlist();
                    var centreid = $('#ddlcentre').val();
                if (centreid == "") {
                    toast("Error", "Please Select Centre", "");
                    return;
                }
                if (FldList == "") {
                    toast("Error", "Please Select fields !","");
                    return ;
                }
                
                serverCall('InvestigationWiseMethod.aspx/searchdataexcel', { investigationid: $('#ddlinvestigation').val(), centreid: centreid, machine: $('#ddlmachine').val(), departmentid: $('#ddldepartment').val(), FldList: FldList }, function (response) {
                $responseData = $.parseJSON(response);
                if ($responseData.status) {
                    if ($responseData.response == 1) {
                        window.open('../common/ExportToExcel.aspx');
                    }
                    else {
                        toast("Error", $responseData.response, "");
                        return;
                    }
                }
                else {
                    toast("Error", $responseData.response, "");
                    return;
                }

            });


        }

        var $bindcentre = function () {
            var $ddlPanel = $('#ddlcentre');
            serverCall('InvestigationWiseMethod.aspx/bindCentre', { TypeId: $('#ddlcentretype').val() }, function (response) {
                $ddlPanel.bindDropDown({ data: JSON.parse(response), valueField: 'centreid', textField: 'centre', defaultValue: "", isSearchAble: true });

            });
        }



    </script>
</asp:Content>

