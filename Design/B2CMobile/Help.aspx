<%@ Page Title="" Language="C#" AutoEventWireup="true"
    CodeFile="Help.aspx.cs" Inherits="Design_PROApp_Help" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/css" />
</head>
<body style="margin-top: -42px">
    <form id="form1" runat="server">
        <Ajax:ScriptManager ID="ScriptManager2" runat="server" LoadScriptsBeforeUI="true" EnablePageMethods="true">
            <Scripts>
                <asp:ScriptReference Path="~/Scripts/jquery-3.1.1.min.js" />
                <asp:ScriptReference Path="~/Scripts/Common.js" />
                <asp:ScriptReference Path="~/Scripts/toastr.min.js" />
                <asp:ScriptReference Path="~/Scripts/jquery.tablednd.js" />
            </Scripts>
        </Ajax:ScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Mobile App B2C Help</b><br />
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Help Content
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Content   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <asp:TextBox ID="txtheader" runat="server" Width="628px"></asp:TextBox>
                    </div>
                </div>
                <div class="row" style="display: none">
                    <div class="col-md-3">
                        <label class="pull-left">Content Text  </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">

                        <asp:TextBox ID="txttext" TextMode="MultiLine" onkeydown="return (event.keyCode!=13);" runat="server" Height="50px" Width="392px"></asp:TextBox>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3"></div>
                    <div class="col-md-10">
                        <asp:CheckBox ID="chkActive" runat="server" /><label for="chkActive">IsActive</label>

                        <asp:Label ID="lblid" runat="server"></asp:Label>
                    </div>
                </div>
                <div class="row" style="text-align: center">
                    <input id="btnsave" type="button" value="Save" class="savebutton" onclick="savehelpdata()" style="cursor: pointer; width: 115px;"
                        tabindex="0" />
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">Search Result</div>
                <div id="row" style="text-align: center">
                    <div class="col-md-24">
                        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch"
                            style="width: 99%; border-collapse: collapse; cursor: move;">
                            <thead>
                                <tr id="Header" class="nodrop">
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 50px;">S.No</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 110px;">Content</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 400px; display: none;">Content</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">IsActive</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Entry Date</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Edit</th>
                                </tr>
                            </thead>

                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="Outer_Box_Inventory" style="width: 99.6%; text-align: center;">
                <input id="Save" type="button" class="searchbutton" value="Save Ordering" />
            </div>

        </div>
    </form>
    <script type="text/javascript">
        $(document).ready(function () {
            SearchHelpdata();
            $("#Save").click(function () {
                saveHelpOrdering();
            });
        });
        function saveHelpOrdering() {
            var InvOrder = "";
            $("#tb_grdLabSearch tr").each(function () {
                if ($(this).attr('id') != "Header")
                    InvOrder += $(this).attr('id') + '|';
            });
            serverCall('Help.aspx/SaveHelpOrdering', { InvOrder: InvOrder }, function (response) {
                if (response == "1") {
                    toast("Success", 'Record Saved Successfully', '');
                  
                    SearchHelpdata();
                    clearform();
                }

            });
        }
        var PatientData = "";
        function SearchHelpdata() {
            var symbol = "";
            jQuery('#tb_grdLabSearch tbody').html('');
            serverCall('Help.aspx/SearchHelpdata', {}, function (response) {
                if (response != "") {
                    var $responseData = JSON.parse(response);
                    if ($responseData != null) {
                        for (var i = 0; i < $responseData.length; i++) {
                            var $appendText = [];
                            $appendText.push('<tr class="GridViewItemStyle" id="'); $appendText.push($responseData[i].ID); $appendText.push('">');
                            $appendText.push('<td > '); $appendText.push(i + 1); $appendText.push('</td>');
                            $appendText.push('<td >'); $appendText.push($responseData[i].HeaderText); $appendText.push('</td>');
                            $appendText.push('<td  style="display:none;">'); $appendText.push($responseData[i].Content); $appendText.push('</td>');
                            $appendText.push('<td  style="font-weight:bold;">'); $appendText.push($responseData[i].IsActive); $appendText.push('</td>');
                            $appendText.push('<td  style="font-weight:bold;">'); $appendText.push($responseData[i].Entrydate); $appendText.push('</td>');
                            $appendText.push('<td  style="font-weight:bold;">'); $appendText.push('<img src="../Purchase/Image/edit.png" style="cursor:pointer;" onclick="GetDataForEdit(this);">'); $appendText.push('</td>');
                            $appendText.push("</tr>");
                            $appendText = $appendText.join("");
                            jQuery('#tb_grdLabSearch tbody').append($appendText);
                        }
                        $("#tb_grdLabSearch").tableDnD
                        ({
                            onDragClass: "GridViewDragItemStyle",
                            onDragStart: function (table, row) {
                            }
                        });
                    }
                }
            });


        };

        function savehelpdata() {
            if ($("#<%=txtheader.ClientID %>").val() == '') {
                
                toast("Error", 'Please Enter Header', '');
                return false;
            }
            $('#msgpro').html('');
            if ($("#<%=chkActive.ClientID%>").prop("checked")) {
                chkActive = 1;
            }
            else {
                chkActive = 0;
            }
            if (document.getElementById('btnsave').value == "Save") {
                serverCall('Help.aspx/SaveHelpContent', { HeaderText: $("#<%=txtheader.ClientID %>").val(), ContentText: $("#<%=txttext.ClientID %>").val(), IsActive: chkActive }, function (response) {
                    if (response == "1") {
                        toast("Success", 'Record Saved Successfully', '');
                        SearchHelpdata();
                        clearform();
                    }


                });
            }
            else {
                serverCall('Help.aspx/UpdateHelpContent', { HeaderText: $("#<%=txtheader.ClientID %>").val(), ContentText: $("#<%=txttext.ClientID %>").val(), IsActive: chkActive, ID: $("#<%=lblid.ClientID %>").val() }, function (response) {
                    if (response == "1") {
                        toast("Success", 'Record Saved Successfully', '');
                        SearchHelpdata();
                        SearchHelpdata();
                        clearform();
                        document.getElementById('btnsave').value = "Save";
                    }
                });

            }
        }

        function GetDataForEdit(el) {
            document.getElementById('btnsave').value = "Update";
            document.getElementById('<%=txtheader.ClientID %>').value = $(el).closest('tr').find('td:eq(1)').text();
            document.getElementById('<%=txttext.ClientID %>').value = $(el).closest('tr').find('td:eq(2)').text();
            document.getElementById('<%=lblid.ClientID %>').value = $(el).closest('tr').attr('id');
            var IsActive = $(el).closest('tr').find('td:eq(3)').text()
            if (IsActive == "Yes") {
                document.getElementById('<%=chkActive.ClientID %>').checked = true;
            }
            else {
                document.getElementById('<%=chkActive.ClientID %>').checked = false;
            }
        }
    </script>
    <script type="text/javascript">
        function clearform() {
            $("#<%=txtheader.ClientID%>").val("");
            $("#<%=txttext.ClientID %>").val("");
            $("#<%=lblid.ClientID %>").val("");
            document.getElementById('<%=chkActive.ClientID %>').checked = false;
        }
    </script>
</body>
</html>
