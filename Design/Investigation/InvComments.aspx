<%@ Page Language="C#" ValidateRequest="false" AutoEventWireup="true" MasterPageFile="~/Design/DefaultHome.master" MaintainScrollPositionOnPostback="true" CodeFile="InvComments.aspx.cs" Inherits="Design_Investigation_InvComments" %>


<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    <div id="Pbody_box_inventory" style="text-align: left;">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Create Comments Template<br />
            </b>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>


        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Select Investigation&nbsp;
            </div>
            <div class="row">
                <div class="col-md-4" id="tdDep" runat="server" style="text-align: right">Department :</div>
                <div class="col-md-6">
                    <asp:DropDownList ID="ddlDepartment" runat="server"
                        AutoPostBack="True" OnSelectedIndexChanged="ddlDepartment_SelectedIndexChanged">
                    </asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-4" id="Div1" runat="server" style="text-align: right">Investigation :</div>
                <div class="col-md-6">
                    <asp:DropDownList ID="ddlInvestigation" runat="server"
                        AutoPostBack="True" OnSelectedIndexChanged="ddlInvestigation_SelectedIndexChanged">
                    </asp:DropDownList>
                </div>
            </div>
            <div class="row">
                <div class="col-md-4" style="text-align: right">
                    Available Comments:
                </div>
            <div class="col-md-10">
                <asp:GridView ID="grdTemplate" runat="server" AutoGenerateColumns="False"
                    CssClass="GridViewStyle" OnRowCommand="grdTemplate_RowCommand">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="Comments_Head" HeaderText="Comments Name">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Investigation" HeaderText="Investigation">
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="350px" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Reject">
                            <ItemTemplate>
                                <asp:ImageButton ID="imbReject" runat="server" CausesValidation="false" CommandArgument='<%#Eval("Comments_ID") %>'
                                    CommandName="Reject" ImageUrl="~/App_Images/Delete.gif" />

                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Edit">
                            <ItemTemplate>
                                <asp:ImageButton ID="imbEdit" runat="server" CausesValidation="False" CommandArgument='<%# Eval("Comments_ID") %>'
                                    CommandName="vEdit" ImageUrl="~/App_Images/edit.png" />

                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
            </div>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                &nbsp;
            </div>
            <div class="row">
                <div class="col-md-10" style="text-align: right">
                    <span style="color: red;">Note:- Font type : Verdana and Font size : 12 &nbsp;</span>
                </div>
              
            </div>
            <div class="row">
                <div class="col-md-4" style="text-align: right">
                    <span style="color: red;">Comments Name :&nbsp;</span>
                </div>
                <div class="col-md-6">
                    <asp:TextBox ID="txtCommentsName" runat="Server" CssClass="ItDoseTextinputText" Visible="true" AutoCompleteType="Disabled" Width="252px"></asp:TextBox>
                </div>
            </div>
            <div class="row">
                <div class="col-md-4" style="text-align: right">
                    <span style="color: red;">Comments Desc :&nbsp;</span>
                </div>
                <div class="col-md-6">
                    <CKEditor:CKEditorControl ID="txtLimit" BasePath="~/ckeditor" runat="server" EnterMode="BR" Height="264px" Width="780px"></CKEditor:CKEditorControl>
                </div>
            </div>

        </div>
        <div class="POuter_Box_Inventory" style="text-align:center">
            <asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" Text="Save" Width="56px" />
        </div>
    </div>

</asp:Content>


