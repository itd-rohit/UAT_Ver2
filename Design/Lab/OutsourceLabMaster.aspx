<%@ Page Language="C#" AutoEventWireup="true" ClientIDMode="Static" CodeFile="OutsourceLabMaster.aspx.cs" Inherits="Design_Lab_OutsourceLabMaster" MasterPageFile="~/Design/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-24">
                    <b>Create OutSource Lab Name</b>
                    <br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: left;">

            <div class="row">
                <div class="col-md-2"></div>
                <div class="col-md-3">
                    <label class="pull-left">Lab Name   </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:TextBox ID="txtLabName" runat="server" MaxLength="100" CssClass="requiredField"></asp:TextBox>
                </div>
                <div class="col-md-1"></div>
                <div class="col-md-3">
                    <label class="pull-left">Contact Person</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:TextBox ID="txtContactPerson" runat="server" MaxLength="100"></asp:TextBox>
                </div>
            </div>
            <div class="row">
                <div class="col-md-2"></div>
                <div class="col-md-3">
                    <label class="pull-left">Address</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:TextBox ID="txtAddress" runat="server" MaxLength="150"></asp:TextBox>
                </div>
                <div class="col-md-1"></div>
                <div class="col-md-3">
                    <label class="pull-left">Phone No.</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:TextBox ID="txtPhone" runat="server" MaxLength="10"></asp:TextBox>
                    <cc1:FilteredTextBoxExtender ID="ftbPhone" runat="server" TargetControlID="txtPhone" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                </div>
            </div>

            <div class="row">
                <div class="col-md-2"></div>
                <div class="col-md-3">
                    <label class="pull-left">Mobile No.</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:TextBox ID="txtMobile" MaxLength="10" runat="server"></asp:TextBox>
                    <cc1:FilteredTextBoxExtender ID="ftbMobile" runat="server" TargetControlID="txtMobile" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                </div>
                <div class="col-md-1"></div>
                <div class="col-md-3">
                    <label class="pull-left">Email ID</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:TextBox ID="txtemail" runat="server" MaxLength="50"></asp:TextBox>
                </div>
            </div>
            <div class="row">
                <div class="col-md-2"></div>
                <div class="col-md-3">
                    <label class="pull-left">Is Active </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-6">
                    <asp:DropDownList ID="ddlActive" runat="server">
                        <asp:ListItem Value="0">No</asp:ListItem>
                        <asp:ListItem Value="1" Selected="True">Yes</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-1"></div>
                <div class="col-md-3">
                    <label class="pull-left">
                        <asp:Label ID="lblUpdateRemark" runat="server" Text="Update Remark"></asp:Label></label>
                    <span runat="server" visible="false" id="spnUpdateRemark"><b class="pull-right">:</b></span>
                </div>
                <div class="col-md-6">
                    <asp:TextBox ID="txtUpdateRemark" runat="server" MaxLength="100" CssClass="requiredField"></asp:TextBox>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row" style="text-align: center">
                <div class="col-md-24">
                    <asp:Button ID="BtnSave" runat="server" Text="Save"  OnClick="BtnSave_Click"  OnClientClick="return validate();" />
                    <asp:Button ID="BtnCancel" runat="server" Text="Cancel" Visible="false" OnClick="BtnCancel_Click" CssClass="buttonClick" OnClientClick="return validateCancel();" />
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row" style="height: 400px; overflow-y: scroll">
                <div class="col-md-24">
                    <asp:Panel ID="Panel1" Height="200" runat="server">
                        <asp:GridView ID="GrdOutsourceLab" AutoGenerateColumns="False" runat="server" CssClass="GridViewStyle" OnSelectedIndexChanged="GrdOutsourceLab_SelectedIndexChanged">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <RowStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Left" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex + 1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Name" HeaderText="Lab Name">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Address" HeaderText="Address">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Phone" HeaderText="Phone No.">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Mobile" HeaderText="Mobile No.">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="ContactPerson" HeaderText="Contact Person">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Emailid" HeaderText="EmailID">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Active" HeaderText="Active">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:BoundField>
                                <asp:BoundField DataField="UpdateRemark" HeaderText="UpdateRemark">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:BoundField>
                                <asp:CommandField ShowSelectButton="True" HeaderStyle-CssClass="GridViewHeaderStyle" HeaderText="Select" ItemStyle-CssClass="buttonClick" />
                                <asp:TemplateField Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblOutsourceLabName" runat="server" Text='<%#Eval("ID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </asp:Panel>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function validate() {
            if ($.trim($("#txtLabName").val()) == "") {
                toast('Error', 'Please Enter Lab Name');
                $("#txtLabName").focus();
                return false;
            }
            if (jQuery('#txtPhone').val().length != 0) {
                if (jQuery('#txtPhone').val().length < 10) {
                    toast("Error", "Incorrect Phone No.", "");
                    jQuery('#txtPhone').focus();
                    return false;
                }
            }
            if (jQuery('#txtMobile').val().length != 0) {
                if (jQuery('#txtMobile').val().length < 10) {
                    toast("Error", "Incorrect Mobile No.", "");
                    jQuery('#txtMobile').focus();
                    return false;
                }
            }
           
            if (jQuery('#txtemail').val().length > 0) {
                var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
                if (!filter.test(jQuery('#txtemail').val())) {
                    toast("Error", 'Incorrect Email ID', '');
                    jQuery('#txtEmail').focus();
                    return false;
                }
            }
            if ($.trim($("#txtUpdateRemark").val()) == "" && $("#BtnSave").val() == "Update") {
                toast('Error', 'Please Enter Update Remarks');
                $("#txtUpdateRemark").focus();
                return false;
            }
            document.getElementById('<%=BtnSave.ClientID%>').disabled = true;
            document.getElementById('<%=BtnSave.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$BtnSave', '');


        }
        function validateCancel() {
            document.getElementById('<%=BtnCancel.ClientID%>').disabled = true;
            document.getElementById('<%=BtnCancel.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$BtnCancel', '');
        }
         </script>
        <script type="text/javascript">
        $(function () {
            $(".buttonClick").click(function () {
                $modelBlockUI();
            });
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(
            function () {
                $modelUnBlockUI();
            });
        });
   $('#txtLabName,#txtContactPerson').alphanum({
            allow: '/-.',
            disallow:'0123456789'
        });
   //$('#txtAddress').alphanum({
   //         allow: '/-.,',
   //         disallow:'0123456789'
   //     });
    </script>
</asp:Content>
