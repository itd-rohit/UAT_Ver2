<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CreateResponse.aspx.cs" Inherits="Design_Support_CreateResponse" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
      <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
    <%: Scripts.Render("~/bundles/confirmMinJS") %>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-24">
                    <b>Manage Response</b>
                </div>
            </div>           
        </div>
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <asp:Panel ID="Panel1" runat="server">
                    <div class="row" style="display: none">
                        <div class="col-md-3">
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Category  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlCategory" runat="server">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row" style="display: none">
                        <div class="col-md-3">
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Type  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlType" runat="server">
                                <asp:ListItem Value="Query" Text="Query">Query</asp:ListItem>
                                <asp:ListItem Value="Response" Selected="True" Text="Response">Response</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row" style="display: none">
                        <div class="col-md-3">
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Main Head  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtMainHead" runat="server"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row Query dynamic" style="display: none" runat="server" visible="false">
                        <div class="col-md-3">
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Query  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtSubject" runat="server"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row Query dynamic" style="display: none" runat="server" visible="false">
                        <div class="col-md-3">
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Detail  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDetail" Visible="false" runat="server" TextMode="MultiLine" Rows="10" Width="449px" Style="max-width: 449px"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Response  </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-7">
                            <asp:TextBox ID="txtResponse" runat="server" MaxLength="100" CssClass="requiredField"></asp:TextBox>
                        </div>
                    </div>
                </asp:Panel>
            </div>
        </div>
        <div class="POuter_Box_Inventory" id="butondiv" style="text-align: center;">
            <div class="row">
                <input type="button" id="btnSave" onclick="SaveResponse()" value="Save" />
                <input id="btnUpdate" type="button" style="display: none" value="Update" onclick="UpdateResponse()" />
                <input id="btnCancel" type="button"  value="Cancel" onclick="clearControl()" />
                <span id="spnID" style="display: none"></span>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <table class="GridViewStyle" cellspacing="0" rules="all" border="1" style="border-collapse: collapse; width: 100%">
                    <thead>
                        <tr>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 30px;">S.No.</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 390px;">Response</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 90px;">Action</th>
                        </tr>
                    </thead>
                    <tbody id="tbResponseDetail">
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $(function () {
            getResponseList();
        });
        function getResponseList() {
            jQuery("#tbResponseDetail").append('');
            serverCall('CreateResponse.aspx/GetQueryList', {}, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    bindDetail($responseData.responseDetail);
                }
                else {
                    toast("Error", $responseData.response);
                }

            });
        }
        function SaveResponse() {
            if ($.trim($("#txtResponse").val()) == "") {
                toast('Error', 'Please Enter Response');
                $("#txtResponse").focus();
                return;
            }
            jQuery("#tbResponseDetail").append('');
            serverCall('CreateResponse.aspx/SaveResponse', { Type: $("#ddlType").val(), Detail: $.trim($("#txtResponse").val()), MainHead: $.trim($("#txtMainHead").val()), CategoryID: 0 }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    toast('Success', $responseData.response);
                    clearControl();
                    bindDetail($responseData.responseDetail);
                }
                else {
                    toast("Error", $responseData.response);
                }
            });
        }
        function clearControl() {
            $("#txtResponse,#txtMainHead").val('');
            $("#spnID").text('');
            $("#btnSave").show();
            $("#btnUpdate").hide();
        }
        function bindDetail(JsonDetail) {
            jQuery("#tbResponseDetail").html('');
         
            if (JsonDetail != "" && JsonDetail != "[]") {
               
                var JsonData = jQuery.parseJSON(JsonDetail);
                for (var i = 0; i < JsonData.length; i++) {
                    var $row = [];
                    $row.push('<tr>');
                    $row.push('<td>'); $row.push(i + 1); $row.push('</td>');
                    $row.push('<td style="text-align:left" id="tdResponse">'); $row.push(JsonData[i]["Detail"]); $row.push('</td>');
                    $row.push('<td><input type="button" value="Edit" id="btnEdit" onclick="EditResponse(this,\''); $row.push(JsonData[i]["Id"]); $row.push('\')">&nbsp;');
                    $row.push('<input type="button" value="Remove" id="btnRemove" onclick="RemoveResponse(this,\''); $row.push(JsonData[i]["Id"]); $row.push('\')">');
                    $row.push('</td>');
                    $row.push('</tr>');
                    $row = $row.join("");
                    jQuery("#tbResponseDetail").append($row);
                }
            }
            
        }
        function EditResponse(rowID, ID) {
            $("#spnID").text(ID);
            $("#txtResponse").val($(rowID).closest('tr').find("#tdResponse").text());
            $("#btnSave").hide();
            $("#btnUpdate").show();
        }
        function RemoveResponse(rowID, ID) {
            $confirmationBox("".concat('<b>Do you want to remove?</b>', '<br/><br/>', "<b>Response :</b>", $(rowID).closest('tr').find("#tdResponse").text()), ID);
        }
        $confirmationBox = function (contentMsg, id) {
            jQuery.confirm({
                title: 'Confirmation!',
                content: contentMsg,
                animation: 'zoom',
                closeAnimation: 'scale',
                useBootstrap: false,
                opacity: 0.5,
                theme: 'light',
                type: 'red',
                typeAnimated: true,
                boxWidth: '480px',
                buttons: {
                    'confirm': {
                        text: 'Yes',
                        useBootstrap: false,
                        btnClass: 'btn-blue',
                        action: function () {
                            serverCall('CreateResponse.aspx/removeResponse', { ID: id }, function (response) {
                                var $responseData = JSON.parse(response);
                                if ($responseData.status) {
                                    toast('Success', $responseData.response);                                   
                                    bindDetail($responseData.responseDetail);
                                }
                                else {
                                    toast('Error', $responseData.response);
                                }
                            });
                        }
                    },
                    somethingElse: {
                        text: 'No',
                        action: function () {
                            $clearAction();
                        }
                    },
                }
            });
        }
        function $clearAction() {

        }
        function UpdateResponse() {
            if ($("#spnID").text() == "") {
                toast("Error", 'Please Select Response');
                return false;
            }
            if ($.trim($("#txtResponse").val()) == "") {
                toast('Error', 'Please Enter Response');
                $("#txtResponse").focus();
                return;
            }
            serverCall('CreateResponse.aspx/updateResponse', { ID: $("#spnID").text(), Detail: $.trim($("#txtResponse").val()), MainHead: $.trim($("#txtMainHead").val()), CategoryID: 0 }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status) {
                    clearControl();
                    toast('Success', $responseData.response);
                    bindDetail($responseData.responseDetail);
                }
                else {
                    toast('Error', $responseData.response);
                }
            });
        }
    </script>
</asp:Content>

