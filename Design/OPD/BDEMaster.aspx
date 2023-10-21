<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="BDEMaster.aspx.cs" Inherits="Design_OPD_BDEMaster" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
          
              
                    <b>BDE Master</b><br />
               
                    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
                    </Ajax:ScriptManager>
                    <asp:Label ID="lblmsg" runat="server" ForeColor="#FF0033"></asp:Label>
           
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Registration &nbsp;</div>
            <table style="width: 100%;border-collapse:collapse">
                <tr>
                    <td style="width: 20%; text-align: right;"  >
                        BDE Name :&nbsp;</td>
                    <td  style="width: 35%;" >
                        <span class="text2"><strong><span style="color: #54a0c0"></span></strong><span style="font-size: 8pt">
                            <asp:DropDownList ID="cmbTitle" runat="server" CssClass="inputbox4" TabIndex="1"
                                ToolTip="select  gender" Width="66px">
                                <asp:ListItem>Mr.</asp:ListItem>
                            </asp:DropDownList>
                            <asp:TextBox ID="txtName" runat="server" CssClass="inputbox3" MaxLength="100" TabIndex="2"
                                Width="147px"></asp:TextBox></span></span></td>
                    <td style="width: 20%;" >
                        </td>
                    <td  style="width: 35%;" >
                    
                        
                            
                    </td>
                </tr>
                <tr style="display:none;">
                    <td  style="width: 15%; " >
                        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    </td>
                    <td  style="width: 35%; " >
                        
                        </td>
                    <td  style="width: 15%; " >
                    </td>
                    <td  style="width: 35%;text-align:left " >
                        <asp:Label ID="Label1" runat="server" ForeColor="#FF0033" Visible="False"></asp:Label></td>
                </tr>
                <tr >
                    <td  style="width: 15%;text-align:right"  >
                        Phone :&nbsp;
                    </td>
                    <td  style="width: 35%" >
                        <asp:TextBox ID="txtPhone1" runat="server" CssClass="inputbox2" MaxLength="20" TabIndex="3"
                            Width="217px"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="ftbPhone1" runat="server" TargetControlID="txtPhone1" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                    </td>
                    <td  style="width: 15%;" >
                        &nbsp;
                    </td>
                    <td  style="width: 35%;" >
                        
                    </td>
                </tr>
                <tr >
                    <td  style="width: 15%;text-align:right"  >
                        Active :&nbsp;
                    </td>
                    <td  style="width: 35%;"  rowspan="2">
                       <asp:CheckBox ID="chkActive" runat="server" Checked="True" />
                            
                            </td>
                    <td  style="width: 15%;" >
                      </td>
                    <td  style="width: 35%;" >
                        
                            </td>
                </tr>
                <tr >
                    <td   style="width: 15%;" >
                    </td>
                    <td  style="width: 15%;" >
                    </td>
                    <td  style="width: 35%;" >
                    </td>
                </tr>
            </table>
        </div>
        <br />
        <br />
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnSave" runat="server" Text="Save" Width="64px" OnClick="btnSave_Click1" />
            <asp:Button ID="btnUpdate" runat="server" Text="Update" Width="64px" Visible="false" OnClick="btnUpdate_Click" /></div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:TextBox ID="txtSearch" runat="server" CssClass="inputbox2" MaxLength="20" TabIndex="3"
                Width="217px"></asp:TextBox>
            <asp:Button ID="btnSearch" runat="server" Text="Search" Width="64px" OnClick="btnSearch_Click1" /></div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                &nbsp;</div>
            <table style="width: 100%">
                <tr>
                    <td style="text-align:center;" valign="top"  colspan="4">
                        &nbsp;<asp:GridView ID="grdShare" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                            Height="74px" TabIndex="7" OnSelectedIndexChanged="grdShare_SelectedIndexChanged">
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemTemplate>
                                        <%# Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="ID" HeaderText="ID" Visible="false">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="BDEName" HeaderText="BDE Name">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="300px" />
                                </asp:BoundField>
                                <%--<asp:BoundField DataField="Age" HeaderText="Age">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                                </asp:BoundField>--%>
                                <%--<asp:BoundField DataField="Mobile" HeaderText="Mobile">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                                </asp:BoundField>--%>
                                <asp:BoundField DataField="Phone" HeaderText="Phone">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="300px" />
                                </asp:BoundField>
                                <%--<asp:BoundField DataField="Address" HeaderText="Address">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="300px" />
                                </asp:BoundField>--%>
                                <%--<asp:BoundField DataField="DOB" HeaderText="DOB">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="300px" />
                                </asp:BoundField>--%>
                                <asp:TemplateField HeaderText="IsActive" Visible="false">
                                    <ItemTemplate>
                                        <div style="display: none;">
                                            <asp:Label ID="lblrecord" runat="server" Text='<%#Eval("ID")+"#"+Eval("bdeName")+"#"+Eval("Phone")+"#"+Eval("IsActive")%>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                                </asp:TemplateField>
                                <asp:CommandField ShowSelectButton="True" SelectText="Edit"  HeaderText="Edit">
                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="80px" />
                        <ItemStyle CssClass="GridViewLabItemStyle" />
                    </asp:CommandField>
                                <%--<asp:TemplateField HeaderText="Edit">
                                    <ItemStyle CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imgEdit" runat="server" ImageUrl="../Purchase/Image/edit.png" />
                                    </ItemTemplate>
                                </asp:TemplateField>--%>
                            </Columns>
                            <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        </asp:GridView>
                    </td>
                </tr>
                </table>
        </div>
    </div>
</asp:Content>
