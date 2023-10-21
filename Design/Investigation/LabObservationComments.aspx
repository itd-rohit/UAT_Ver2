
<%@ Page Language="C#" ValidateRequest="false" AutoEventWireup="true" MasterPageFile="~/Design/DefaultHome.master" MaintainScrollPositionOnPostback="true" CodeFile="LabObservationComments.aspx.cs" Inherits="Design_Investigation_InvComments" %>

<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %> 
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>



<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
 <div id="body_box_inventory" style="width: 970px;text-align:left;" >
    <div class="Outer_Box_Inventory" style="width: 962px;">
    <div class="content">
    <div style="text-align:center;">
    <b>Create Comments Template<br />
    </b>
    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />    </div>
   </div>
   </div>
      
    <div class="Outer_Box_Inventory" style="width: 962px; ">
    <div class="Purchaseheader">
        Select Observation&nbsp;</div>
        <table style="width: 953px">
            
            <tr>
                <td align="right" style="width: 211px; height: 13px" valign="middle" class="ItDoseLabel">
                    Observation:</td>
                <td align="left"  style="width: 334px; height: 13px" valign="middle">
                    <asp:DropDownList ID="ddlObservation" runat="server" CssClass="ItDoseDropdownbox"
                        Width="376px" AutoPostBack="True" OnSelectedIndexChanged="ddlObservation_SelectedIndexChanged">
                    </asp:DropDownList></td>
                <td align="right"  style="font-size: 8pt; width: 111px; color: #000000;
                    font-family: Verdana; height: 13px; text-align: left;" valign="middle">
                    </td>
                <td align="left"  style="font-weight: bold; height: 13px; width: 377px;" valign="middle">
                </td>
            </tr>
            <tr>
                <td align="right" class="ItDoseLabel" style="width: 211px; height: 13px" valign="middle">
                    Available Comments:</td>
                <td align="left" colspan="3" valign="middle">
                    <asp:GridView ID="grdTemplate" runat="server" AutoGenerateColumns="False" 
                    CssClass="GridViewStyle" OnRowCommand="grdTemplate_RowCommand" >
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>                            
                            <asp:TemplateField HeaderText="S.No">
                                <ItemTemplate>
                                    <%#Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="Comments_Head" HeaderText="Comments Name" >
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Investigation" HeaderText="LabObservation" >
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
                                   <ItemStyle CssClass="GridViewItemStyle"  />
                                 <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Left" />
                            </asp:TemplateField>
                        </Columns>
                     
                                <HeaderStyle HorizontalAlign="Left" />
                    </asp:GridView>
                </td>
            </tr>
            <tr style="font-size: 10pt; font-family: Arial">
                <td align="right" style="height: 14px; text-align: center;" valign="middle" class="ItDoseLabel" colspan="4">
                    &nbsp;</td>
            </tr>
        </table>
    </div>
         <div class="Outer_Box_Inventory" style="width: 962px; ">
             <div class="Purchaseheader">
                 &nbsp;</div>
             <table style="width: 100%" border="0" cellpadding="0" cellspacing="0">
                 <tr>
                     <td align="right" style="width: 13%;" valign="middle" class="ItDoseLabel">
                     </td><td align="right" style="width: 87%;" valign="middle" class="ItDoseLabel">
                     </td>
                 </tr>
                 <tr>
                     <td align="right" class="ItDoseLabel" style="width: 13%" valign="middle">
                         Comments Name :&nbsp;
                     </td>
                     <td align="right" class="ItDoseLabel" style="width: 87%; text-align: left" valign="middle">
                         <asp:TextBox ID="txtCommentsName" runat="Server" CssClass="ItDoseTextinputText" Visible="true" AutoCompleteType="Disabled" Width="252px"></asp:TextBox>
                
                         </td>
                 </tr>
                 <tr>
                     <td align="right" class="ItDoseLabel" style="width: 13%" valign="top">
                         Comments Desc :&nbsp;
                     </td>
                     <td align="right" class="ItDoseLabel" style="width: 100%; text-align: left" valign="middle">
                      <%--<CE:Editor ID="txtLimit" runat="server"  Style="font-family:Arial;"  AutoConfigure="Simple"  />--%>
                         <ckeditor:ckeditorcontrol ID="txtLimit"  BasePath="~/ckeditor" runat="server"    EnterMode="BR" Height="180px" Width="780px"></ckeditor:ckeditorcontrol>
                         </td>
                 </tr>
               
                 <tr>
                     <td align="right" style="width: 13%;" valign="middle" class="ItDoseLabel">
                     </td>
                     <td align="right" style="width: 87%; text-align: left;" valign="middle" class="ItDoseLabel">
                         <asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" Text="Save" Width="56px" />
                         &nbsp;&nbsp;&nbsp;
                     </td>
                 </tr>
            <tr style="font-size: 10pt; font-family: Arial">
                <td align="right" style="width: 13%;" valign="middle" class="ItDoseLabel">
                </td><td align="right" style="width: 87%;" valign="middle" class="ItDoseLabel">
                </td>
            </tr>
        </table>
</div>
      </div>
 
  </asp:Content>


