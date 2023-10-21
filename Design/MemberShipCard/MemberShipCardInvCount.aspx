<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="MemberShipCardInvCount.aspx.cs" Inherits="Design_OPD_MemberShipCard_MemberShipCardInvCount" %>



<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

     <Ajax:ScriptManager ID="sm" runat="server"/>

    <%-- Script tag for search validate save update cancel --%>
       <Ajax:UpdatePanel id="UpdatePanel6" runat="server">
                    <contenttemplate>
     <div id="Pbody_box_inventory">
    <div class="POuter_Box_Inventory" style="width: 99.7%">
    <div class="content" style="text-align:center;">
        <span style="font-size: 12pt"><strong>Membership Card 
            Investigation Count<br />
        </strong>
            <asp:Label ID="lblmsg" runat="server" Font-Bold="True" Font-Size="9pt" ForeColor="Red"></asp:Label></span></div>
    </div>

          <div class="Outer_Box_Inventory" style="width: 99.7%">
          <div class="Purchaseheader">
         Search Card And Investigation
            
          </div>
           <table style="width:100%;">
                  <tr>
                      <td><strong>MemebrShip card:</strong>
             
        <asp:DropDownList ID="ddlMembershipCard" runat="server" AutoPostBack="True"  Width="400px"
        OnSelectedIndexChanged="ddlLoginType_SelectedIndexChanged">
        </asp:DropDownList>
             
              </td>
                      
                     
                  </tr>
                
                  <tr>
                      <td  style="text-align: left;vertical-align:top;">
                          <div style="height:500px;overflow:auto;">

                          
                          <asp:GridView ID="grv"  runat="server" CssClass="GridViewStyle" Font-Bold="true" AutoGenerateColumns="False" EnableModelValidation="True" >
                          <Columns>
                              <asp:TemplateField HeaderText="Sr No">
                                  <EditItemTemplate>
                                      <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
                                  </EditItemTemplate>
                                  <ItemTemplate>
                                     <%#Container.DataItemIndex+1 %>
                                  </ItemTemplate>
                                  <ItemStyle CssClass="GridViewItemStyle"  />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                              </asp:TemplateField>
                               <asp:TemplateField HeaderText="Depatment">
                                  <ItemTemplate>
                                      <asp:Label ID="dewd" runat="server" Text='<%# Bind("deptname") %>'></asp:Label>
                                    
                                  </ItemTemplate>
                                  <ItemStyle CssClass="GridViewItemStyle"  />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                              </asp:TemplateField>

                              <asp:TemplateField HeaderText="TestName">
                                  <ItemTemplate>
                                      <asp:Label ID="Label2" runat="server" Text='<%# Bind("invname") %>'></asp:Label>
                                      <asp:Label ID="lbinv" runat="server" Text='<%#Bind("ItemID") %>' Visible="false" />
                                  </ItemTemplate>
                                  <ItemStyle CssClass="GridViewItemStyle"  />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                              </asp:TemplateField>
                              <asp:TemplateField HeaderText="Count">
                                  <ItemTemplate>
                                      <asp:TextBox ID="txtcount" runat="server" Text='<%# Bind("invcount") %>' Width="40px" MaxLength="3"></asp:TextBox>
                                     <cc1:FilteredTextBoxExtender ID="fltMobile" runat="server" FilterType="Numbers" TargetControlID="txtcount">
                            </cc1:FilteredTextBoxExtender>
                                  </ItemTemplate>
                                  <ItemStyle CssClass="GridViewItemStyle"  />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                              </asp:TemplateField>
                              <asp:TemplateField HeaderText="Select">
                               
                                  <ItemTemplate>
                                     <asp:CheckBox ID="ch" runat="server" />
                                  </ItemTemplate>
                                  <ItemStyle CssClass="GridViewItemStyle"  />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                              </asp:TemplateField>
                          </Columns>
                          </asp:GridView>
                              </div></td>
                     
                  </tr>
                
                <tr>
                      <td  style="text-align: center"><asp:Button ID="save" OnClick="save_Click" runat="server" Text="Save" style="font-weight: 700" /></td>
                     
                  </tr>
                      </table>
              </div>
         </div>
</contenttemplate>
                       
                    </Ajax:UpdatePanel>
</asp:Content>

