<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" EnableEventValidation="false" CodeFile="AddInterpretation.aspx.cs" Inherits="Design_Investigation_AddInterpretation" Title="Interpretation" ValidateRequest="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <webopt:BundleReference ID="BundleReference2" runat="server" Path="~/App_Style/chosen.css" />
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sm1" runat="server" />
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Add Interpretation<br />
            </b>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            <asp:RadioButtonList ID="RadioButtonList1" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="RadioButtonList1_SelectedIndexChanged" Style="display: none;">
                <asp:ListItem Selected="True" Value="0">Observation</asp:ListItem>
                <asp:ListItem Value="1">Investigation</asp:ListItem>
            </asp:RadioButtonList>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Select Investigation
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-right">Investigation<b class="pull-right">:</b></label>
                </div>
                <div class="col-md-7">
                    <asp:DropDownList ID="ddlInvestigation" runat="server" OnSelectedIndexChanged="ddlInvestigation_SelectedIndexChanged" AutoPostBack="true">
                    </asp:DropDownList>
                </div>
                <div class="col-md-8">
                    <asp:CheckBox ID="chkshwinv" runat="server" Text="Show In Investigation" Checked="true" />
                    <asp:CheckBox ID="chkshwpkg" runat="server" Text="Show In Package" Checked="true" />
                </div>
                <div class="col-md-6">
                </div>
            </div>
            <div class="row" id="mm" runat="server">
                <div class="col-md-3">
                    <asp:Label ID="lblObs" runat="server" Text="Observation: "></asp:Label>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlObservation" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlObservation_SelectedIndexChanged">
                    </asp:DropDownList>
                </div>
            </div>
            <div class="row" id="mm2" runat="server">
                <div class="col-md-3">
                    Status:
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlstatus" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlstatus_SelectedIndexChanged">
                        <asp:ListItem Value="Normal">Normal</asp:ListItem>
                        <asp:ListItem Value="High">High</asp:ListItem>
                        <asp:ListItem Value="Low">Low</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-right">Centre<b class="pull-right">:</b></label>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlCentre" CssClass="ddlCentre chosen-select" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlCentre_SelectedIndexChanged"></asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <asp:CheckBox ID="chkAllCentre" runat="server" Text="For All Centre" />
                </div>
                <div class="col-md-2">
                    <label class="pull-right">Machine<b class="pull-right">:</b></label>
                </div>
                <div class="col-md-4">
                    <asp:DropDownList ID="ddlMac" CssClass="ddlMac chosen-select" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlMac_SelectedIndexChanged">
                    </asp:DropDownList>
                </div>
                <div class="col-md-10">
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-right"></label>
                </div>
                <div class="col-md-21">
                     <span style="color: red;">Note:- Font type : Verdana and Font size : 12 &nbsp;</span>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-right">Interpretation<b class="pull-right">:</b></label>
                </div>
                <div class="col-md-21">
                    <CKEditor:CKEditorControl ID="txtInvInterpretaion" BasePath="~/ckeditor" runat="server" EnterMode="BR" Height="200px" Width="780px"></CKEditor:CKEditorControl>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnsave" runat="server" Text="Save Interpretation" OnClick="btnsave_Click" Style="cursor: pointer;"  OnClientClick="return validate();"/>
        </div>
    </div>
     <script type="text/javascript">
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
         });
         function validate() {
            document.getElementById('<%=btnsave.ClientID%>').disabled = true;
            document.getElementById('<%=btnsave.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnsave', '');


        }
        </script>
</asp:Content>

