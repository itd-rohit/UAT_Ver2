<%@ Page Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="FormulaMaster.aspx.cs" Inherits="Design_Lab_FormulaMaster"  %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <strong>Formula Creation&nbsp;</strong><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>

        <div class="POuter_Box_Inventory">
            Investigation :&nbsp;
    <asp:DropDownList ID="ddlInvestigations" runat="server" Width="300px" AutoPostBack="True" OnSelectedIndexChanged="ddlInvestigations_SelectedIndexChanged" />&nbsp;
        </div>


        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Privilege Detail     
            </div>

            <div style="float: left; clear: both; width: 435px">
                Observations<br />
                <asp:ListBox ID="lstObservations" runat="server" Height="228px" SelectionMode="Multiple" CssClass="ItDoseListbox" Width="418px"></asp:ListBox>

                <table style="width:100%;border-collapse:collapse;text-align:center">
                    <tr>
                        <td >
                            <asp:Button ID="btnSave" OnClick="btnSave_Click" runat="server" Text="Save" CssClass="ItDoseButton" ></asp:Button>
                       &nbsp;
                            <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="ItDoseButton" OnClick="btnDelete_Click" ></asp:Button></td>
                    </tr>
                </table>

            </div>
            <table>
                <tr>
                    <td style="height: 167px">
                        <asp:Button ID="btnLeft" Text="LEFT" runat="server" CssClass="ItDoseButton" Width="50px" Height="24px" OnClick="btnLeft_Click" />
                        <br />
                        <asp:Button ID="BtnRight" Text="RIGHT" runat="server" CssClass="ItDoseButton" Width="50px" Height="24px" OnClick="BtnRight_Click" /></td>
                    <td style="height: 167px">
                        <asp:TextBox ID="txtLeft" runat="server" Height="20px" Width="161px"></asp:TextBox></td>
                    <td>
                        <label>=</label>
                    </td>
                    <td style="width: 269px; height: 167px;">
                        <asp:TextBox runat="server" ID="txtRight" TextMode="MultiLine" Height="181px" Width="261px"></asp:TextBox></td>
                </tr>
            </table>
            <table>
                <tr>
                    <td>
                        <asp:TextBox runat="server" ID="txtObservationID" Height="20px" Width="161px"></asp:TextBox></td>
                </tr>
            </table>
        </div>

       
    </div>
</asp:Content>

