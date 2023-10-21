<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="UserPagemaster.aspx.cs" Inherits="Design_EDP_UserPagemaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script src="../../Scripts/Message.js" type="text/javascript"></script>
    <script type="text/javascript">
        function showDirectory() {
            var val = window.showModalDialog("browseDirectory.aspx", 'view', "dialogHeight: 480px; dialogWidth: 340px; edge: Raised; center: Yes; help: Yes; resizable: Yes; status: No;");

            if (val != undefined)
                document.getElementById('<%=txtURL.ClientID %>').value = val;


            return false;
        }
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            var MaxLength = 100;
            $('#txtDescription').bind("keypress", function (e) {
                if (window.event) {
                    keynum = e.keyCode
                }
                else if (e.which) {
                    keynum = e.which
                }
                keychar = String.fromCharCode(keynum)
                if (e.keyCode == 39 || keychar == "'") {
                    return false;
                }
                if ($(this).val().length >= MaxLength) {
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
            });
            bindPages();
        });
        function bindPages() {
            serverCall('UserPagemaster.aspx/bindPages', {}, function (response) {
                 DiscountData = JSON.parse(response);
                if (DiscountData != null && DiscountData != "") {
                    var output = $('#tb_DiscountSearch').parseTemplate(DiscountData);
                    $('#DisSearchOutput').html(output);
                    $('#DisSearchOutput').show();


                }
                else {
                    $('#DisSearchOutput').html();
                    $('#DisSearchOutput').hide();
                    $('#lblMsg').text('Record Not Found');

                }
            });
        }
        function chkAll(rowID) {
            if ($(".chkAll").is(':checked'))
                $(".chkSelect").prop('checked', 'checked');
            else
                $(".chkSelect").prop('checked', false);
        }
        function chkSelect(rowID) {
            if ($(".chkSelect").length == $(".chkSelect:checked").length)
                $(".chkAll").prop("checked", "checked");
            else
                $(".chkAll").prop('checked', false);

        }
        function DeletePage()
        {
            var PageId = "";
            $("#tb_ItemList tr").find("#chkSelect").filter(':checked').each(function () {
                PageId = PageId == '' ? $(this).closest('tr').attr('id') : PageId + ',' + $(this).closest('tr').attr('id');
            });
            if (PageId == "") {
                $('#lblMsg').text('Please select Page to delete !!');
                return;
            }
            serverCall('UserPagemaster.aspx/DeletePages', {PageID:PageId}, function (response) {
               Result = JSON.parse(response);
               if (Result == "1") {
                   $('#lblMsg').text('Page Deleted successfully !!');
                }
                else {
                    $('#lblMsg').text('Some Error Record !!');
                }
            });
        }
        function SaveAuthorizationPage() {
            if ($.trim($('#txtFileName').val()) == "") {
                $('#lblMsg').text('Please Enter File Name');
                $('#txtFileName').focus();
                return false;
            }
            if ($.trim($('#txtURL').val()) == "") {
                $('#lblMsg').text('Please Enter URL');
                $('#txtURL').focus();
                return false;
            }
            $("#lblMsg").text('');
            $('#btnSave').attr('disabled', 'disabled').val("Submiting...");
            var data = new Array();
            var obj = new Object();


            obj.FileName = $("#txtFileName").val();
            obj.URL = $("#txtURL").val();

            data.push(obj);
            if (data.length > 0) {
                $.ajax({
                    url: "Services/EDP.asmx/SaveAuthorizePage",
                    data: JSON.stringify({ Data: data }),
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        if (result.d == "1") {
                            $("#lblMsg").text('Record Saved Successfully');

                            $("#txtFileName").val('');
                            $("#txtURL").val('');

                        }
                        else if (result.d == "2") {
                            $("#lblMsg").text('Already Page Exists');
                        }
                        else {
                            $("#lblMsg").text('Error occurred, Please contact administrator');
                        }
                        $('#btnSave').attr('disabled', false).val("Save");
                    },
                    error: function (xhr, status) {
                        $("#lblMsg").text('Record Not Saved');
                        $('#btnSave').attr('disabled', false).val("Save");
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
        }


        $(document).ready(function () {

        });
    </script>
    <div id="Pbody_box_inventory">
        <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <%--Ankur 14-08-15--%>
            <b>USER Authorization Master</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                File&nbsp;Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFileName" AutoCompleteType="Disabled" ClientIDMode="Static" runat="server" MaxLength="50" Width="95%"></asp:TextBox>
                            <asp:Label ID="Label1" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                URL
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-13">
                            <asp:TextBox ID="txtURL" runat="server" AutoCompleteType="Disabled" Font-Bold="true" MaxLength="70"
                                Width="240px" ClientIDMode="Static"></asp:TextBox>
                            <a href="javascript:void(0);" onclick="showDirectory();">
                                <img src="../../Images/view.GIF" style="border: none;" alt="" /></a>
                            <asp:Label ID="Label2" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                            <asp:Label ID="lblFile" runat="server" CssClass="ItDoseLabelSp" Text="(URL&nbsp; : /Design/Folder/FileName.aspx)"></asp:Label>
                        </div>

                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <input type="button" value="Save" id="btnSave" onclick="SaveAuthorizationPage()" class="ItDoseButton" />
            <input type="button" value="Delete Page" class="searchbutton" onclick="DeletePage('', '1')" />
        </div>
         <div class="POuter_Box_Inventory" >
        <div class="Purchaseheader">
           User Page List
        </div>
        <div class="row">
            <div class="col-md-24">
                <div class="content" id="DisSearchOutput" style="overflow: scroll; height: 130px;">
                    
                </div>
            </div>
        </div>
    </div>
    </div>
    <div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" Text="Button" CssClass="ItDoseButton" />
    </div>
    <cc1:ModalPopupExtender ID="mpeCreateFrame" runat="server" CancelControlID="btnRCancel"
        DropShadow="true" TargetControlID="btnHidden" BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlFrame" PopupDragHandleControlID="dragHandle" BehaviorID="mpeCreateFrame" OnCancelScript="ClearPopup();">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="pnlFrame" runat="server" CssClass="pnlFilter" Style="display: none; width: 260px; height: 94px">
        <div id="Div1" class="Purchaseheader" runat="server">
            New Frame &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Press
            esc to close
        </div>

        <table width="100%">
            <tr>
                <td align="center">
                    <asp:Label ID="lblFrame" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" />
                </td>

            </tr>
            <tr>
                <td>Frame :&nbsp;
            <asp:TextBox ID="txtNFrame" runat="server" ClientIDMode="Static" Font-Bold="true" MaxLength="20"></asp:TextBox>
                    <asp:Label ID="Label5" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                </td>

            </tr>
        </table>

        <div class="filterOpDiv">
            <input id="btnSaveCity" type="button" class="ItDoseButton" value="Save" onclick="SaveFrameMaster()" />
            &nbsp;<asp:Button ID="btnRCancel" runat="server" CssClass="ItDoseButton" Text="Cancel" />
        </div>
    </asp:Panel>
    <script id="tb_DiscountSearch" type="text/html">
          <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_ItemList"
    style="width:980px;border-collapse:collapse;">
                        <tr id="header">
                            <td class="GridViewHeaderStyle"  style="text-align: center;">Page Name</td>
                            <td class="GridViewHeaderStyle"  style="text-align: center;">URL</td>
                            <td class="GridViewHeaderStyle"  style="text-align: center;">
                                <input type="checkbox" class="chkAll"  onclick="chkAll(this)"  /></td>
                           
                        </tr>
                        <#
        var dataLength=DiscountData.length;
        var objRow;
        for(var j=0;j<dataLength;j++)
        {
        objRow = DiscountData[j];
        #>
                    <tr id="<#=objRow.ID#>">
                  

                   <td class="GridViewLabItemStyle" id="tdBookingCentre" style="text-align:left"><#=objRow.PageName#></td>
                        <td class="GridViewLabItemStyle" id="tdvisitno" style="text-align:left"><#=objRow.URL#></td>
                      <td class="GridViewLabItemStyle" style="text-align: center;">
                        <input type="checkbox" id="chkSelect"  onclick="chkSelect(this)" class="chkSelect"  />
                    </td>
                        </tr>
                     <#}

        #>
        
     </table>
    </script>
</asp:Content>
