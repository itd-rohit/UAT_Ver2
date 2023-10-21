<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="SubGroup.aspx.cs" Inherits="Design_OPD_SubGroup" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
        <div id="Pbody_box_inventory">
             
        <div class="POuter_Box_Inventory" style="text-align: center;">


            <b>Sub Group</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />


        </div>
             <div class="POuter_Box_Inventory" style="text-align: center;">
        <table  style="width: 100%;border-collapse:collapse">
                 <tr>
                <td style="width: 15%; ">
                </td>
                <td colspan="2" style="">
                    <asp:Label ID="Label1" runat="server" Font-Bold="True" ForeColor="#FF8080"></asp:Label></td>
            </tr>
            <tr>
                <td style="width: 15%">
                </td>
                <td style="width: 35%">
                </td>
                <td style="width: 50%">
                </td>
            </tr>
            <tr>
                <td style="width: 15%">
                </td>
                <td style="width: 35%">
                    <asp:RadioButton ID="rdbNew" runat="server" Font-Bold="True"   GroupName="SAME" OnCheckedChanged="rdbNew_CheckedChanged"
                        Text="ADD NEW" AutoPostBack="True" />&nbsp;
                    <asp:RadioButton ID="rdbEdit" runat="server" Checked="True" Font-Bold="True" GroupName="SAME"
                        OnCheckedChanged="rdbEdit_CheckedChanged" Text="EDIT OLD" AutoPostBack="True" /></td>
                <td style="width: 50%">
                </td>
            </tr>
            
            <tr>
                <td style="width: 15%">
                </td>
                <td style="width: 35%">
                </td>
                <td style="width: 50%">
                </td>
            </tr>
            <tr>
                <td style="width: 15%; text-align: right">
                    Name :&nbsp;</td>
                <td style="width: 35%;text-align:left">
                    <asp:TextBox ID="TextBox1" runat="server" Width="260px"></asp:TextBox>
                  Department:  &nbsp;<asp:DropDownList ID="ddldept" runat="server" Width="100px"></asp:DropDownList>
                </td>
                <td style="width: 50%;text-align:left">
                    <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Save" Width="61px" /></td>
            </tr>
       
            <tr>
                <td style="width: 15%">
                </td>
                <td style="width: 35%">
                </td>
                <td style="width: 50%">
                </td>
            </tr>
            <tr>
                <td style="width: 15%;text-align: right">
                    Search By Name :&nbsp;</td>
                <td style="width: 35%;text-align:left">
                    <asp:TextBox ID="TextBox2" runat="server" Width="260px"></asp:TextBox></td>
                <td style="width: 50%;text-align:left">
                    <asp:Button ID="Button2" runat="server" OnClick="Button2_Click" Text="View" Width="61px" /></td>
            </tr>
            <tr>
                <td style="width: 15%">
                </td>
                <td colspan="2">
                    <div style="overflow:scroll;height:500px">
                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" OnSelectedIndexChanged="GridView1_SelectedIndexChanged">
                        <Columns>
                            <asp:BoundField DataField="SubgroupName" HeaderText="Sub Group">
                                <ItemStyle Width="350px" />
                            </asp:BoundField>
                          
                              <asp:BoundField DataField="DepartmentName" HeaderText="DepartmentName">
                                <ItemStyle Width="350px" />
                            </asp:BoundField>
                            <asp:CommandField ShowSelectButton="True">
                                <ItemStyle Width="75px" />
                            </asp:CommandField>
                            <asp:TemplateField Visible="False">
                                <ItemTemplate>
                                    <asp:Label ID="lblBank" runat="server" Text='<%# Eval("ID") %>'></asp:Label>
                                    <asp:Label ID="lbldeptid" runat="server" Text='<%# Eval("SubCategoryID") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView></div>
                </td>
            </tr>
            <tr>
                <td style="width: 15%">
                </td>
                <td style="width: 35%">
                </td>
                <td style="width: 50%">
                </td>
            </tr>
        </table>
                 </div>
</div>

</asp:Content>

