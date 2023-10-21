<%@ Page ClientIDMode="Static" Language="C#" AutoEventWireup="true" MasterPageFile="~/Design/DefaultHome.master"
    CodeFile="UserRight.aspx.cs" Inherits="Design_EDP_UserRight" EnableEventValidation="false" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/jquery.tablednd.js"></script>
    <div id="Pbody_box_inventory">     
         <ajax:ScriptManager ID="sm" runat="server"></ajax:ScriptManager>  
        <div class="POuter_Box_Inventory" style="text-align: center;">       
                <b>Role Management</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />         
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Role
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:DropDownList ID="ddlLoginType"  runat="server" />
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left">
                                Menu
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-8">
                            <asp:DropDownList ID="ddlMenu"  runat="server" />
                        </div>
                        <div class="col-md-3">

                            </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Avail.&nbsp;Menu
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-21">
                            <asp:Label ID="lblMenu" runat="server" CssClass="ItDoseLblSpBl" />
                            &nbsp;<input type="button" value="Change Menu Order" class="ItDoseButton" onclick="showMenu()" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Privilege Detail
            </div>
            <table style="width: 100%">
                <tr>
                    <td></td>
                    <td>Available</td>
                    <td></td>
                    <td>Remaining
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <td>
                        <img id="move-up" src="../../App_Images/Up.png" alt="" title="Click to move up" />
                        <br />
                        <br />
                        <img id="move-down" src="../../App_Images/Down.png" alt="" title="Click to move down"/></td>
                    <td style="width:522px;">
                        <asp:ListBox ID="lstAvailAbleRight" runat="server" Height="400px" SelectionMode="Multiple"
                            CssClass="ItDoseListbox" Width="540px"></asp:ListBox>
                    </td>
                    <td>
                        <br />
                        <img id="right" src="../../App_Images/Right.png" alt="" />
                        <br />
                        <br />
                        <br />
                        <br />
                        <img id="left" src="../../App_Images/Left.png" alt="" />
                        </td>
                        <td>
                            <asp:ListBox ID="lstRight" runat="server" SelectionMode="Multiple" Height="400px"
                                Width="540px" CssClass="ItDoseListbox"></asp:ListBox>
                        </td>
                        <td>&nbsp;</td>
                </tr>
            </table>

        </div>
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <input id="btnGenerate" type="button" class="ItDoseButton" value="Generate Menu" />

            </div>
        </div>
    </div>
    <asp:Panel ID="pnlMenu" runat="server" CssClass="pnlItemsFilter" Style="display: none"
        Width="320px">
        <div id="Div1" class="Purchaseheader" runat="server">
            Arrange Menu&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
              <em><span style="font-size: 7.5pt">Press esc or click
                            <img src="../../App_Images/Delete.gif" style="cursor: pointer" onclick="closeMenu()" />

                  to close</span></em>
        </div>
        <table style="width: 100%; text-align: center">
            <tr>
                <td colspan="2" style="text-align: center">
                    <div id="div_MenuName" style="overflow: auto; width: 300px">
                    </div>
                </td>
            </tr>
            <tr>

                <td colspan="2" style="text-align: center">
                    <input type="button" onclick="saveMenuOrder();" value="Save" class="ItDoseButton" id="btnSaveMenu" title="Click To Save" />
                    &nbsp;
                                    <asp:Button ID="btnRCancel" runat="server" CssClass="ItDoseButton" Text="Cancel"
                                        ToolTip="Click To Cancel" />
                </td>
            </tr>
        </table>
    </asp:Panel>
    <cc1:modalpopupextender ID="mpMenu" runat="server" BackgroundCssClass="filterPupupBackground"
        CancelControlID="btnRCancel" DropShadow="true" PopupControlID="pnlMenu"
        TargetControlID="btnNewMenu" OnCancelScript="closeMenu()" BehaviorID="mpMenu">
    </cc1:modalpopupextender>
    <asp:Button ID="btnNewMenu" Style="display: none" runat="server" />
        <script type="text/javascript">    
            $(document).ready(function () {
                var uid = '<%=Session["userid"]%>';
                if (uid != '1' && uid !='') {

                    document.getElementById('btnGenerate').style.visibility = 'hidden';
                  
                }
                else {
                    document.getElementById('btnGenerate').style.visibility = 'visible';
                }


            });
            function moveUp() {
                if ($('#lstAvailAbleRight option:selected').val() == null) {
                $('#lblMsg').text('Please Select To Move Up');
                return false;
            }
            $('#lblMsg').text('');
            $('#lstAvailAbleRight :selected').each(function (i, selected) {
                $(this).insertBefore($(this).prev());
            });
        }
        function moveDown() {
            if ($('#lstAvailAbleRight option:selected').val() == null) {
                $('#lblMsg').text('Please Select To Move Down');
                return false;
            }
            $('#lblMsg').text('');
            $('#lstAvailAbleRight :selected').each(function (i, selected) {
                $(this).insertAfter($(this).next());
            });
        }
        function UpdateSNo(e) {
            var list = new Array();
            var obj = new Object();
            var i = 1;
            $('#lstAvailAbleRight option').each(function () {
                obj.UrlID = $(this).val();
                obj.SNo = i;
                list.push(obj);
                i = i + 1;
                obj = new Object();
            });
            serverCall('Services/EDP.asmx/UpdateMenuSNo', { RoleID: $('#ddlLoginType').val(), RoleName: $('#ddlLoginType option:selected').text(), fileRoleList: list }, function (response) {
                if (response == "1")
                    $("#lblMsg").text('Menu Generated Successfully');
                else
                    $("#lblMsg").text('Error occurred, Please contact administrator');
            });        
            return;
        }
    </script>
    <script type="text/javascript">
        function showMenu() {
            $find('mpMenu').show();
            serverCall('Services/EDP.asmx/bindMenu', { RoleID: $('#ddlLoginType').val() }, function (response) {
                var $Data = JSON.parse(response);
                if ($Data.length > 0) {
                    $("#div_MenuName").empty();
                    var $table = [];
                    $table.push("<table id='tblResult' cellspacing='0' rules='all' border='1'><tr id='Header'> <th class='GridViewHeaderStyle' style='width:20px; ' scope='col'>S.No.</th> <th class='GridViewHeaderStyle' style='width:300px;'>MenuName</th><th class='GridViewHeaderStyle' style='width:30px;display:none'>MenuID</th></tr><tbody>");
                    for (var i = 0; i < $Data.length; i++) {
                        var $row = [];
                        $row.push("<tr>");
                        $row.push("<td class='GridViewLabItemStyle' id='tdID' style='width:20px;cursor:pointer '>" + (i + 1) + "</td>");
                        $row.push("<td class='GridViewLabItemStyle'  id='tdMenuName' style='width:300px;cursor:pointer'>" + $Data[i].MenuName + "</td>");
                        $row.push("<td class='GridViewLabItemStyle'  id='tdMenuID' style='width:30px;cursor:pointer;display:none'>" + $Data[i].MenuID + "</td>");
                        $row.push("</tr>");
                        $row = $row.join(" ");
                        $table.push($row);
                    }
                    $table.push("</tbody></table>");
                    $table = $table.join(" ");
                    $("#div_MenuName").append($table);
                    $("#tblResult").tableDnD({
                        onDragClass: "GridViewDragItemStyle",
                        onDragStart: function (table, row) {
                        }
                    });
                }
            });           
        }
        function closeMenu() {
            $find('mpMenu').hide();
        }
        function bindMenuSNo() {
            var dataMenu = new Array();
            var ObjMenu = new Object();
            var SNo = 1;
            $("#tblResult tr").each(function () {
                var id = $(this).closest("tr").attr("id");
                $rowid = $(this).closest('tr');
                if (id != "Header") {
                    ObjMenu.SNo = SNo;
                    ObjMenu.MenuID = $.trim($rowid.find("#tdMenuID").text());
                    dataMenu.push(ObjMenu);
                    SNo = SNo + 1;
                    ObjMenu = new Object();
                }
                return dataMenu;
            });
        }
        function saveMenuOrder() {
            var dataMenu = new Array();
            var ObjMenu = new Object();
            var SNo = 1;
            $("#tblResult tr").each(function () {
                var id = $(this).closest("tr").attr("id");
                $rowid = $(this).closest('tr');
                if ((id != "Header") && ($rowid.find("#tdMenuID").text() != "")) {
                    ObjMenu.SNo = SNo;
                    ObjMenu.MenuID = $.trim($rowid.find("#tdMenuID").text());
                    ObjMenu.RoleID = $('#ddlLoginType').val();
                    dataMenu.push(ObjMenu);
                    SNo = SNo + 1;
                    ObjMenu = new Object();
                }
            });
            serverCall('Services/EDP.asmx/UpdateMenu', { menu: dataMenu }, function (response) {
                bindLoadAvailMenu();
                if (response == "1")
                    $("#lblMsg").text('Menu Order Saved Successfully And Generate Successfully');
                else
                    $("#lblMsg").text('Error occurred, Please contact administrator');
                $find('mpMenu').hide();
            });           
        }
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find('mpMenu')) {
                    $find('mpMenu').hide();
                }
            }
        }
    </script>
    <script type="text/javascript">
        function bindLoginType() {
            $("#ddlLoginType option").remove();
            var $ddlLoginType = $('#ddlLoginType');
            serverCall('Services/EDP.asmx/bindLoginType', {  }, function (response) {             
                $ddlLoginType.bindDropDown({ data: JSON.parse(response), valueField: 'ID', textField: 'RoleName', isSearchAble: true });             
                bindLoadAvailMenu();
            });
        }
        function bindLoadMenu() {
            $("#ddlMenu option").remove();
            var $ddlMenu = $('#ddlMenu');
            serverCall('Services/EDP.asmx/bindLoadMenu', {}, function (response) {
                $ddlMenu.bindDropDown({ data: JSON.parse(response), valueField: 'ID', textField: 'MenuName', isSearchAble: true });                
            });          
        }
        function bindLoadAvailMenu() {
            serverCall('Services/EDP.asmx/LoadAvailMenu', { RoleID:$('#ddlLoginType').val()}, function (response) {
                AvailMenu = response;
                $("#lblMenu").text(AvailMenu);
            });            
        }
        $(function () {
            bindLoadMenu();
            bindLoginType();
            
            $("#ddlLoginType").on("change", function () {
                bindPage();
                bindAvailRight();
                bindLoadAvailMenu();
            });
            $("#ddlMenu").on("change", function () {
                bindPage();
                bindAvailRight();
            });
            $('#move-up').click(moveUp);
            $('#move-down').click(moveDown);
            $('#btnGenerate').click(UpdateSNo);
            $('#btnSaveMenu').click(UpdateSNo);
            $("#right").bind("click", function () {
                $('#lstRight option').prop("selected", false);
                var cond = 0;
                if ($('#lstAvailAbleRight option:selected').text() == "") {
                    $('#lblMsg').text('Please Select Available');
                    return false;
                    cond = 1;
                }
                if (cond == 0) {
                    var options = $('#lstAvailAbleRight option:selected');
                    for (var i = 0; i < options.length; i++) {
                        var opt = $(options[i]).clone();
                        $(options[i]).remove();
                        $('#lstRight').append(opt);
                    }
                    var data = new Array();
                    $('#lstRight option').each(function () {
                        var obj = new Object();
                        obj.URLId = $(this).val();
                        obj.RoleID = $('#ddlLoginType').val();
                        data.push(obj);
                    });
                    if (data.length > 0) {
                        serverCall('services/EDP.asmx/RoleUpdate', { Data: data }, function (response) {
                            if (response == 1)
                                $('#lblMsg').text('Record Update Successfully');
                            $('#lstRight option').attr("selected", false);
                        });
                    }
                }
                else {
                    $('#lblMsg').text('Please Select Available');
                    return false;
                }
            });
            $("#left").bind("click", function () {
                var cond = 0;
                if ($('#lstRight option:selected').text() == "") {
                    $('#lblMsg').text('Please Select Remaining');
                    cond = 1;
                    return false;
                }
                if (cond == 0) {
                    $('#lblMsg').text('');
                    var options = $('#lstRight option:selected');
                    for (var i = 0; i < options.length; i++) {
                        var opt = $(options[i]).clone();
                        $(options[i]).remove();
                        $('#lstAvailAbleRight').append(opt);
                    }
                    var data = new Array();
                    $('#lstAvailAbleRight option').each(function () {
                        var obj = new Object();
                        obj.URLId = $(this).val();
                        obj.RoleID = $('#ddlLoginType').val();
                        data.push(obj);
                    });
                    if (data.length > 0) {
                        serverCall('services/EDP.asmx/RoleInsert', { Data: data }, function (response) {
                            if (response == 1)
                                $('#lblMsg').text('Record Update Successfully');
                            $('#lstAvailAbleRight option').attr("selected", false);
                        });
                    }
                }
                else {
                    $('#lblMsg').text('Please Select Remaining');
                    return false;
                }
            });
        });
        function bindPage() {
            var $lstRight = $("#lstRight");
            $("#lstRight option").remove();
            serverCall('services/EDP.asmx/BindPage', { LoginType:$("#ddlLoginType").val() ,MenuId: $("#ddlMenu").val() }, function (response) {               
                if (response != "")
                    $lstRight.bindListBox({ data: JSON.parse(response), valueField: 'id', textField: 'FileName' });
            });           
        }
        function bindAvailRight() {
            var $AvailAbleRight = $("#lstAvailAbleRight");
            $("#lstAvailAbleRight option").remove();
            serverCall('services/EDP.asmx/BindAvailRight', { RoleID: $("#ddlLoginType").val(), MenuId: $("#ddlMenu").val() }, function (response) {
                if(response!="")
                    $AvailAbleRight.bindListBox({ data: JSON.parse(response), valueField: 'ID', textField: 'FileName' });
            });           
        }       
    </script>
</asp:Content>
