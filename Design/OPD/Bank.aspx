<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="Bank.aspx.cs" Inherits="Design_OPD_Bank" %>


    <asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
        <div id="Pbody_box_inventory">
             
        <div class="POuter_Box_Inventory" style="text-align: center;">


            <b>Bank Master</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />


        </div>
             <div class="POuter_Box_Inventory" style="text-align: center;">
        <table  style="width: 100%;border-collapse:collapse">
            
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
                    <asp:TextBox ID="TextBox1" runat="server" Width="260px"></asp:TextBox></td>
                <td style="width: 50%;text-align:left">
                    <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Save" Width="61px" /></td>
            </tr>
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
                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" OnSelectedIndexChanged="GridView1_SelectedIndexChanged">
                        <Columns>
                            <asp:BoundField DataField="BankName" HeaderText="Bank Name">
                                <ItemStyle Width="350px" />
                            </asp:BoundField>
                            <asp:CommandField ShowSelectButton="True">
                                <ItemStyle Width="75px" />
                            </asp:CommandField>
                            <asp:TemplateField Visible="False">
                                <ItemTemplate>
                                    <asp:Label ID="lblBank" runat="server" Text='<%# Eval("Bank_ID") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
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
    