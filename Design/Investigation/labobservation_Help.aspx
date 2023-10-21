<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="labobservation_Help.aspx.cs" Inherits="Design_Investigation_labobservation_Help" Title="Set Observation Help Menu" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
       <%: System.Web.Optimization.Scripts.Render("~/bundles/MsAjaxJs") %>


    
    &nbsp;<Ajax:ScriptManager ID="ScriptManager1" runat="server"></Ajax:ScriptManager>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">



            <div style="text-align: center;">
                <strong>Investigation Lab Observation Help<br />
                </strong>
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
        </div>


        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Select Observation
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="labelForTag" style="width: 100px">
                                Investigation :</label>
                </div>
                <div class="col-md-6">
                    <asp:DropDownList ID="ddlInvestigation" runat="server" CssClass="ItDoseDropdownbox"
                                Width="376px" AutoPostBack="True" OnSelectedIndexChanged="ddlInvestigation_SelectedIndexChanged">
                            </asp:DropDownList>
                </div>
                <div class="col-md-15"></div>
            </div>
             <div class="row">
                <div class="col-md-3">
                    <label class="labelForTag" style="width: 100px">
                                Observation&nbsp; :</label>
                </div>
                  <div class="col-md-6">
                      <asp:DropDownList ID="ddlobservation" runat="server" CssClass="ItDoseDropdownbox"
                                Width="376px" AutoPostBack="True" OnSelectedIndexChanged="ddlobservation_SelectedIndexChanged">
                            </asp:DropDownList>
                </div>
                <div class="col-md-15">

                </div>
                </div>
             <div class="row">
                <div class="col-md-3">
                    <label class="labelForTag" style="width: 98px;">
                                Help &nbsp;:</label>
                </div>
                <div class="col-md-6">
                    <asp:ListBox ID="ListBox1" runat="server" Height="88px" Width="376px"
                                SelectionMode="Multiple"></asp:ListBox>
                </div>
                 <div class="col-md-15" style="text-align:right">
                     <div style="float: right; padding: 30px 30px; border: thin solid black; position: relative; bottom: 0px; right: 30px; width: 400px; text-align: center">
                    Detail:
             <div id="ListBoxVal">
             </div>
                </div>
                </div>
            </div>
             <div class="row">
                <div class="col-md-9">

                </div>
               <div class="col-md-2">
                    <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Map" Width="104px" />
                </div>
                <div class="col-md-2">
                    <asp:Button ID="BttnAddHelp" runat="server" Text="Add New Help" Width="104px"/>
                </div>
                <div class="col-md-2">
                    <asp:Button ID="btnEdit" runat="server" Text="EditHelp" Width="104px" OnClick="btnEdit_Click" />
                </div>
                <div class="col-md-9">
                </div>
            </div>
            <div class="content">
                
       
                
                

            </div>
        </div>
        <div class="POuter_Box_Inventory" >
            <div class="Purchaseheader">
                All Observation
            </div>
            <div class="row">
                <Ajax:UpdatePanel ID="update" runat="server">
                    <ContentTemplate>
                        <asp:GridView ID="grdObs" runat="server" AutoGenerateColumns="False" ShowHeader="true" Width="99%" OnRowCommand="grdObs_RowCommand">
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="35px" />
                                </asp:TemplateField>
                                <asp:TemplateField ItemStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>
                                        Observation
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%# Eval("Name")%>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField Visible="false">
                                    <HeaderTemplate>
                                        Observation
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lblid" runat="server" Text='<%#Eval("ID") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField ItemStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>
                                        Help Header
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%# Eval("ShortKey")%>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>

                                <asp:TemplateField ItemStyle-HorizontalAlign="Left">
                                    <HeaderTemplate>
                                        Help Name
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%# Eval("Help")%>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>



                                <asp:CommandField Visible="false" ShowSelectButton="True">
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                </asp:CommandField>
                                <asp:TemplateField>
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imbRemove" runat="server" ImageUrl="~/App_Images/Delete.gif" OnClientClick="return DeleteConfirmation();"
                                            CausesValidation="false" CommandArgument='<%#Container.DataItemIndex %>' CommandName="imbRemove" />

                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>

                    </ContentTemplate>
                </Ajax:UpdatePanel>
            </div>
        </div>
    </div>
    &nbsp;
 <asp:Panel ID="pnlSave" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none;" Width="390px">
     <div class="Purchaseheader" id="Div1" runat="server">
         Add Help
     </div>
     <div class="content">
         &nbsp;&nbsp;
        &nbsp;&nbsp;<br />
         <label class="labelForTag" style="width: 116px">
             Help Header:
         </label>
         <asp:TextBox ID="txtshortkey" runat="server" CssClass="ItDoseTextinputText" Width="188px"></asp:TextBox>&nbsp;&nbsp;<br />
         <label class="labelForTag" style="width: 116px">
             Help:</label>
         <asp:TextBox ID="txtHelp" runat="server" CssClass="ItDoseTextinputText" MaxLength="200" Width="188px"></asp:TextBox>&nbsp;<br />
         &nbsp;&nbsp;
                  <label class="labelForTag" style="width: 116px">
             Is Bold :<asp:CheckBox ID="chkisbold" runat="server" />
         </label>
     </div>
     <div class="filterOpDiv" style="text-align: center">
         &nbsp;&nbsp;
            
        <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="ItDoseButton" Width="65px" ValidationGroup="Save" OnClick="btnSave_Click" />&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Button ID="btnCancel" runat="server" Text="Cancel" CausesValidation="false" CssClass="ItDoseButton" Width="55px" />
     </div>
 </asp:Panel>

    <asp:Panel ID="pnlEdit" runat="server" CssClass="pnlVendorItemsFilter" Style="display: none;" Width="390px">
        <div class="Purchaseheader" id="Div3" runat="server">
            Update Help
        </div>
        <div class="content">
            &nbsp;&nbsp;
        &nbsp;&nbsp;<br />
            <label class="labelForTag" style="width: 116px">
                Help Header:
            </label>
            &nbsp;&nbsp;<br />
            <asp:TextBox ID="txtheader" runat="server" CssClass="ItDoseTextinputText" MaxLength="200" Width="188px"></asp:TextBox>&nbsp;<br />

            <label class="labelForTag" style="width: 116px">
                Help:</label>
            <asp:TextBox ID="txtEdit" runat="server" CssClass="ItDoseTextinputText" MaxLength="200" Width="188px"></asp:TextBox>&nbsp;<br />
         &nbsp;&nbsp;
                  <label class="labelForTag" style="width: 116px">
             Is Bold :<asp:CheckBox ID="chkisBoldEdit" runat="server" />
         </label>
        </div>
        <div class="filterOpDiv" style="text-align: center">
            &nbsp;&nbsp;
            
        <asp:Button ID="btnEditUpdate" runat="server" Text="Update" CssClass="ItDoseButton" Width="65px" OnClick="btnEditUpdate_Click" />&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Button ID="btnEditCancel" runat="server" Text="Cancel" CausesValidation="false" CssClass="ItDoseButton" Width="55px" />
        </div>
    </asp:Panel>

    <cc1:ModalPopupExtender ID="mdpSave" runat="server"
        CancelControlID="btnCancel"
        DropShadow="true"
        TargetControlID="BttnAddHelp"
        BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlSave"
        PopupDragHandleControlID="pnlSave">
    </cc1:ModalPopupExtender>

    <cc1:ModalPopupExtender ID="mdpEditHelp" runat="server"
        CancelControlID="btnCancel"
        DropShadow="true"
        TargetControlID="btnHidden"
        BackgroundCssClass="filterPupupBackground"
        PopupControlID="pnlEdit"
        PopupDragHandleControlID="pnlEdit">
    </cc1:ModalPopupExtender>
    <div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" Text="Button" Style="display: none;"></asp:Button>
        <asp:Button ID="btnHidden1" runat="server" Text="Button" Style="display: none;"></asp:Button>


    </div>
    <script type="text/javascript">

        $(document).ready(function () {

            var Investigation_ID = '<%=InvID %>';
            if (Investigation_ID != "") {
                $('#ctl00_ddlUserName').hide();
                $('.Hider').hide();
            }
            else {


                $('#ctl00_ddlUserName').show();
                $('.Hider').show();
            }


        });</script>
    <script type="text/javascript">
        function DeleteConfirmation() {
            if (confirm("Are you sure,you want to delete selected records ?") == true)

                return true;
            else
                return false;
        }
        $(function () {
            $("select[id*='ListBox1']").change(function () {
                var value = "";
                $(this).find("option:selected").each(function () {
                    value = value + $(this).val();
                    if ($(this).val().split('#')[1] != "") {
                        value = value.split('#')[1] + "</br>";
                    }
                    else {
                        value = value.split('#')[1] + "</br>" + $(this).text();
                    }
                });
                $("#ListBoxVal").html(value);
            });
        });
    </script>
</asp:Content>
