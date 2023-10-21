<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true"
    CodeFile="CurrencyFactor_Master.aspx.cs" Inherits="Design_Master_CurrencyFactor_Master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="aspx" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>



<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server"></cc1:ToolkitScriptManager>

    <script type="text/javascript">
        $(function () {
            $('#txtSaleBase').keyup(function () {
                $('#txtBuyBase').val(Number($('#txtSaleBase').val()));
                var saleSpecific = 1 / Number($('#txtSaleBase').val());
                var buySpecific = 1 / Number($('#txtBuyBase').val());
                saleSpecific = Math.round(eval(saleSpecific) * 10000) / 10000;
                //alert(saleSpecific);
                var CFactor = Number(saleSpecific);
                var round = Math.round((1 - Math.round((CFactor * Number($('#txtSaleBase').val())) * 10000) / 10000) * 10000) / 10000;
                //CFactor = Number(CFactor) + Number(round);
                $('#txtRound').val(round);
                $('#txtsaleSpecific').val(CFactor);
                $('#txtBuySpecific').val(CFactor);
            })
        })
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Currency Factor</b><br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Currency Factor Details
            </div>
            <table style="width: 100%">
                <tr>
                    <td style="text-align: right; width: 198px">Date :
                    </td>
                    <td style="width: 235px" class="left-align">
                        <asp:TextBox ID="txtDate" runat="server" ClientIDMode="Static" TabIndex="1"
                            ToolTip="Click To Select From Date"></asp:TextBox>
                        <cc1:CalendarExtender ID="Fromdatecal" runat="server" Animated="true"
                            Format="dd-MMM-yyyy" TargetControlID="txtDate">
                        </cc1:CalendarExtender>
                    </td>
                    <td style="width: 139px; text-align: right">Base Currency :
                    </td>
                    <td class="left-align">
                        <asp:DropDownList Width="233" ID="ddlBaseCurrency" runat="server" Enabled="False" CssClass="requiredField">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 198px">Specific Currency :
                    </td>
                    <td style="width: 235px" class="left-align">
                        <asp:DropDownList ID="ddlSpecificCurrency" runat="server" AutoPostBack="True"
                            OnSelectedIndexChanged="ddlSpecificCurrency_SelectedIndexChanged" CssClass="requiredField">
                        </asp:DropDownList>
                    </td>
                    <td style="width: 139px; text-align: right">&nbsp;
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td style="text-align: right; width: 198px">Specific Notation :
                    </td>
                    <td style="width: 235px" class="left-align">
                        <asp:Label ID="lblNotation" runat="server" Style="color: #800000"></asp:Label>
                    </td>
                    <td style="width: 139px; text-align: right">&nbsp;
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td style="text-align: center; text-decoration: underline;" colspan="4">
                      </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
              <div class="Purchaseheader">
                 Conversion Factor Details
            </div>
            <table style="width: 100%">
                <tr>
                    <td style="text-align: right;" colspan="4">
                        <table style="width: 100%">
                            <tr>
                                <td colspan="4" style="text-align: center; text-decoration: underline">
                                    <strong style="text-align: center">Selling Price</strong></td>
                                <td colspan="4" style="text-align: center; text-decoration: underline">
                                    <strong>Buying Price</strong></td>
                            </tr>
                            <tr>
                                <td>In Base <asp:Label ID="lblSaleInBase" runat="server" Font-Bold="true" ></asp:Label>=</td>
                                <td style="text-align: left">
                                    <asp:TextBox ID="txtSaleBase" ClientIDMode="Static" runat="server" Width="70px" CssClass="requiredField"></asp:TextBox>
                                    <asp:Label ID="lblSaleBase" runat="server" Font-Bold="true" ></asp:Label>
                                </td>
                                <td>In Specific <asp:Label ID="lblSaleInSpecific" runat="server" Font-Bold="true" ></asp:Label>=
                                </td>
                                <td style="text-align: left">
                                    <asp:TextBox ID="txtsaleSpecific" ClientIDMode="Static" runat="server" Width="70px" CssClass="requiredField"></asp:TextBox>
                                    <asp:Label ID="lblSaleSpecific" runat="server" Font-Bold="true" ></asp:Label>
                                </td>
                                <td>In Base <asp:Label ID="lblBuyInBase" runat="server" Font-Bold="true" ></asp:Label>=</td>
                                <td style="text-align: left">
                                    <asp:TextBox ID="txtBuyBase" ClientIDMode="Static" runat="server" Width="70px" CssClass="requiredField"></asp:TextBox>
                                     <asp:Label ID="lblBuyBase" runat="server" Font-Bold="true" ></asp:Label>
                                </td>
                                <td>In Specific <asp:Label ID="lblBuyInSpecific" runat="server" Font-Bold="true" ></asp:Label>=</td>
                                <td style="text-align: left">
                                    <asp:TextBox ID="txtBuySpecific" ClientIDMode="Static" runat="server" Width="70px" CssClass="requiredField"></asp:TextBox>
                                    <asp:Label ID="lblBuySpecific" runat="server" Font-Bold="true" ></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: left">&nbsp;</td>
                                <td style="margin-left: 40px; text-align: left;">&nbsp;</td>
                                <td style="text-align: right">Round :</td>
                                <td style="text-align: left">
                                    <asp:DropDownList ID="ddlRound" runat="server">
                                        <asp:ListItem Value="0" Text="0"></asp:ListItem>
                                        <asp:ListItem Value="1" Text="1"></asp:ListItem>
                                        <asp:ListItem Value="2" Text="2" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="3" Text="3"></asp:ListItem>
                                        <asp:ListItem Value="4" Text="4"></asp:ListItem>
                                        <asp:ListItem Value="5" Text="5"></asp:ListItem>
                                        <asp:ListItem Value="6" Text="6"></asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:TextBox ID="txtRound" ClientIDMode="Static" runat="server" Width="70px" style="display:none"></asp:TextBox>
                                </td>
                                <td style="text-align: right">Lowest Receivable Currency:</td>
                                <td style="text-align: left">
                                    <asp:TextBox ID="txtminCurrency" ClientIDMode="Static" runat="server" Width="70px"></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="fc2" runat="server" FilterType="Numbers" TargetControlID="txtminCurrency"></cc1:FilteredTextBoxExtender>
                                    (In Digit Only)
                                </td>
                                <td style="text-align: left">&nbsp;</td>
                                <td style="text-align: left">&nbsp;</td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td style="margin-left: 40px">&nbsp;</td>
                                <td>&nbsp;</td>
                                <td style="text-align: center" colspan="2"></td>
                                <td style="text-align: left">&nbsp;</td>
                                <td>&nbsp;</td>
                                <td style="text-align: left">&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        



        <div style="text-align: center" class="POuter_Box_Inventory">
            <asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" Text="Save" CssClass="save margin-top-on-btn" />
        </div>
         
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Currency Details
            </div>
            <div class="row">
                <div class="col-md-24">

                    <asp:GridView ID="grdCurrencyDetails" Width="100%" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No." ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%#Container.DataItemIndex+1 %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Currency" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%#Eval("S_Currency") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Notation" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%#Eval("S_Notation")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Selling Base" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%#Eval("Selling_Base")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Selling Specific" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%#Eval("Selling_Specific")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Buying Base" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%#Eval("Buying_Base")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Buying Specific" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%#Eval("Buying_Specific")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Round" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%#Eval("Round")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="MinCurrency" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%#Eval("MinCurrency")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Date" ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%#Eval("Date")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>

        </div>
        </div>
</asp:Content>
