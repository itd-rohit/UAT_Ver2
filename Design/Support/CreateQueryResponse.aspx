<%@ Page ClientIDMode="Static" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="CreateQueryResponse.aspx.cs" Inherits="Design_Support_CreateQueryResponse" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
   
    <link rel="stylesheet" href="../../App_Style/jquery-confirm.min.css">
    <%: Scripts.Render("~/bundles/confirmMinJS") %>
   
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-24">
                    <b>Manage Query</b>
                </div>                              
            </div>
        </div>
        <div class="POuter_Box_Inventory" id="divSubmitQuery">
            <asp:Panel ID="Panel1" runat="server">
                <div class="row">
                    <div class="col-md-3">
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Category  </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-7">
                        <asp:DropDownList ID="ddlCategory" runat="server" CssClass="requiredField">
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
                    <div class="col-md-7">
                        <asp:DropDownList ID="ddlType" runat="server">
                            <asp:ListItem Value="Query" Text="Query" Selected="True">Query</asp:ListItem>
                            <asp:ListItem Value="Response" Text="Response">Response</asp:ListItem>
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
                    <div class="col-md-7">
                        <asp:TextBox ID="txtMainHead" runat="server" CssClass="requiredField" MaxLength="50"></asp:TextBox>
                    </div>
                </div>
                <div class="row Query dynamic" style="display: none">
                    <div class="col-md-3">
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Query</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-7">
                        <asp:TextBox ID="txtSubject" runat="server" CssClass="requiredField" MaxLength="50"></asp:TextBox>
                    </div>
                </div>
                <div class="row Query dynamic" style="display: none">
                    <div class="col-md-3">
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Detail</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-7">
                        <asp:TextBox ID="txtDetail" runat="server" TextMode="MultiLine" Rows="10" Columns="20" Style="height: 80px;" CssClass="requiredField"></asp:TextBox>
                    </div>
                </div>
                <div class="row Response dynamic" style="display: none">
                    <div class="col-md-3">
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Detail</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-7">

                       
                  <asp:TextBox ID="txtResponse" runat="server" TextMode="MultiLine" Rows="10" Width="449px" CssClass="requiredField"></asp:TextBox>

                    </div>
                </div>
            </asp:Panel>
        </div>
        <div class="POuter_Box_Inventory" id="butondiv" style="text-align: center;">
            <input type="button" id="btnSave" onclick="SaveResponse()" value="Save" />
            <input id="btnUpdate" type="button" style="display: none" value="Update" onclick="UpdateDetails()" />
            <input id="btnCancel" type="button" style="display: none" value="Cancel" onclick="Cancle()" />
          
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <table class="GridViewStyle" cellspacing="0" rules="all" border="1" style="border-collapse: collapse; width: 100%">
                    <thead>
                        <tr>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 30px;">S.No.</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Category</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 140px;">Query</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 390px;">Details</th>
                            <th class="GridViewHeaderStyle" scope="col" style="width: 90px;">Action</th>
                        </tr>
                    </thead>
                    <tbody id="tbresponseDetail">
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function clearControl() {
            $("#txtSubject,#txtDetail,#txtMainHead").val('');
        }
        function SaveResponse() {
            if ($("#ddlCategory").val() == 0) {
                toast('Error', 'Please Select Category');
                $("#ddlCategory").focus();
                return;
            }
            if ($.trim($("#txtSubject").val()) == "") {
                toast('Error', 'Please Enter Query');
                $("#txtSubject").focus();
                return;
            }
            if ($.trim($("#txtDetail").val()) == "") {
                toast('Error', 'Please Enter Detail');
                $("#txtDetail").focus();
                return;
            }
            serverCall('CreateQueryResponse.aspx/SaveResponse', { Type: 'Query', Subject: $.trim($("#txtSubject").val()), Detail: $.trim($("#txtDetail").val()), MainHead: $.trim($("#txtMainHead").val()), CategoryID: $("#ddlCategory").val() }, function (response) {
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
        $(function () {
            $('.dynamic').hide();
            $('.Query').show();
            $("#ddlCategory").chosen("destroy").chosen({ width: '100%' });
        });             
        function RemoveCatgory(rowID,id) {
            $confirmationBox("".concat('<b>Do you want to remove?</b>', '<br/><br/>', "<b>Category :</b>", $(rowID).closest('tr').find("#tdCategoryName").text(), '<br/>', "<b>Query :</b>", $(rowID).closest('tr').find("#tdSUBJECT").text()), id);
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
                            serverCall('Services/Support.asmx/DeleteQuery', { Id: id }, function (response) {
                                var $responseData = JSON.parse(response);
                                if ($responseData.status) {
                                    toast('Success', $responseData.response);
                                }
                                else {
                                    toast('Error', $responseData.response);
                                }
                                GetQueryList($("#ddlCategory").val());                             
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
        function GetQueryList(Id) {
            $("#tbresponseDetail").html('');
        serverCall('CreateQueryResponse.aspx/getDetail', { CategoryID: Id }, function (response) {
            var $responseData = JSON.parse(response);
            if ($responseData.status) {
                bindDetail($responseData.responseDetail);
            }
            else {
                toast('Error', $responseData.response);
            }
        });
    }

        function bindDetail(JsonDetail) {
            jQuery("#tbResponseDetail").html('');
            var JsonData = jQuery.parseJSON(JsonDetail);
            if (JsonData != "" && JsonDetail != "[]") {
                for (var i = 0; i < JsonData.length; i++) {
                    var $row = [];
                    $row.push('<tr>');
                    $row.push('<td>'); $row.push(i + 1); $row.push('</td>');
                    $row.push('<td style="text-align:left" id="tdCategoryName">'); $row.push(JsonData[i]["CategoryName"]); $row.push('</td>');
                    $row.push('<td style="text-align:left;display:none" id="tdCategoryID">'); $row.push(JsonData[i]["CategoryID"]); $row.push('</td>');
                    $row.push('<td style="text-align:left" id="tdSUBJECT">'); $row.push(JsonData[i]["SUBJECT"]); $row.push('</td>');
                    $row.push('<td style="text-align:left" id="tdDetail">'); $row.push(JsonData[i]["Detail"]); $row.push('</td>');
                    $row.push('<td><input type="button" value="Edit" id="btnEdit" onclick="EditCatgory(this,\''); $row.push(JsonData[i]["Id"]); $row.push('\')">&nbsp;');
                    $row.push('<input type="button" value="Remove" id="btnRemove" onclick="RemoveCatgory(this,\''); $row.push(JsonData[i]["Id"]); $row.push('\')">');
                    $row.push('</td>');
                    $row.push('</tr>');
                    $row = $row.join("");
                    jQuery("#tbresponseDetail").append($row);
                }
            }
            else {
                toast('Info', $responseData.response);
            }

        }
    $("#ddlCategory").change(function () {
        if (this.value == 0) {
            $("#tbresponseDetail").html('');
            return false;
        }
        GetQueryList(this.value);
    });
    var QueryID = "";
    function EditCatgory(rowID, QId) {
        $("#ddlCategory").val($(rowID).closest('tr').find("#tdCategoryID").text()).attr('disabled', 'disabled');        
        $("#ddlCategory").chosen('destroy').chosen();
        QueryID = QId;
        $("#txtSubject").val($(rowID).closest('tr').find("#tdSUBJECT").text());
        $("#txtDetail").val($(rowID).closest('tr').find("#tdDetail").text());
        $("#btnSave").hide();
        $("#btnUpdate,#btnCancel").show();
    }

    function UpdateDetails() {
        if (QueryID == "") {
            toast("Error", 'Please Select Category');
            return false;
        }
        if ($.trim($("#txtSubject").val()) == '') {
            toast("Error", 'Please Enter Query');
            $("#txtSubject").focus();
            return false;
        }
        if ($.trim($("#txtDetail").val()) == '') {
            toast("Error", 'Please Enter Detail');
            $("#txtDetail").focus();
            return false;
        }
        serverCall('Services/Support.asmx/UpdateQuery2', { Id: QueryID, CategoryID: $("#ddlCategory").val(), subject: $("#txtSubject").val(), detail: $("#txtDetail").val() }, function (response) {
            var $responseData = JSON.parse(response);
            if ($responseData.status) {
                toast('Success', $responseData.response);
                GetQueryList($("#ddlCategory").val());
                Cancle();
            }
            else {
                toast('Error', $responseData.response);
            }
        });
    }

    function Cancle() {
        $("#ddlCategory").removeAttr('disabled');
        $("#txtSubject,#txtDetail").val('');
        $("#btnSave").show();
        $("#btnUpdate,#btnCancel").hide();
        $("#ddlCategory").prop('selectedIndex', 0)
        $("#ddlCategory").chosen("destroy").chosen({ width: '100%' });
    }
 $('#txtSubject').alphanum({
            allow: '.',
            disallow:'0123456789'
        });
    </script>

</asp:Content>

