<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ConcentFormMaster.aspx.cs" Inherits="Design_Investigation_ConcentFormMaster" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
        <script type="text/javascript">
            function ShowImagePreview(input) {
                if (input.files && input.files[0]) {
                    var reader = new FileReader();
                    reader.onload = function (e) {
                       
                        $('#ContentPlaceHolder1_mm').attr('src', e.target.result);
                };
                reader.readAsDataURL(input.files[0]);
                }
            }


            function openme() {
                window.open('ConcentFormFields.aspx', null, 'left=100, top=100, height=520, width=830, status=no, resizable= yes, scrollbars= yes, toolbar= no,location= no, menubar= no');

            }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>&nbsp;Concent Form Master</b>&nbsp;<br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-4">
                    <strong>Concent Form Name:</strong>
                </div>
                <div class="col-md-3">
                    <asp:TextBox ID="txtname" MaxLength="20" runat="server" Style="text-transform: uppercase"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ErrorMessage="Required" ControlToValidate="txtname"
                        runat="server" Display="Static" ForeColor="Red" ValidationGroup="a" /><asp:Label ID="mmid" runat="server" Visible="false"></asp:Label>
                </div>
                <div class="col-md-2"></div>
                <div class="col-md-7" style="text-align: right; font-weight: 700; vertical-align: top">
                    <input type="button" value="Add Fields" style="float: left; font-weight: bold; cursor: pointer; display: none;" onclick="openme()" />&nbsp;&nbsp;
                            <asp:Button ID="btnrefresh" runat="server" OnClick="btnrefresh_Click" Style="float: left; font-weight: bold; cursor: pointer; display: none;" Text="Refresh Fields" />
                    Upload File:<asp:FileUpload ID="file" runat="server" onchange="ShowImagePreview(this);" />

                </div>
                <div class="col-md-2" style="display:none">
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ErrorMessage="Required" ControlToValidate="file"
                        runat="server" Display="Static" ForeColor="Red" ValidationGroup="a" />
                    &nbsp;<asp:RegularExpressionValidator ID="RegularExpressionValidator1" ValidationExpression="([a-zA-Z0-9\s_\\.\-:])+(.png|.jpg|.PNG|.JPG|.JPEG|.jpeg)$"
                        ControlToValidate="file" runat="server" ForeColor="Red" ErrorMessage="Only Image File" ValidationGroup="a"
                        Display="Static" />
                </div>
            </div>
            <div class="row">
                <div class="col-md-9">
                    <div class="row">
                        <div class="Purchaseheader">Show Fields </div>
                    </div>
                    <div class="row">
                        <asp:GridView ID="mygrid" Width="99%" runat="server" AutoGenerateColumns="False" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="3" EnableModelValidation="True" OnRowDataBound="mygrid_RowDataBound">
                            <Columns>
                                <asp:TemplateField HeaderText="Fields">

                                    <ItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Bind("Fieldsname") %>' Font-Bold="true"></asp:Label>
                                        <asp:Label ID="Label2" runat="server" Text='<%# Bind("id") %>' Visible="false"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Left">
                                    <EditItemTemplate>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:TextBox ID="txtleft" runat="server" Width="30px"></asp:TextBox>
                                        <cc1:FilteredTextBoxExtender ID="fltMobile" runat="server" FilterType="Numbers, Custom" TargetControlID="txtleft" ValidChars=".">
                                        </cc1:FilteredTextBoxExtender>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Top">

                                    <ItemTemplate>
                                        <asp:TextBox ID="txttop" runat="server" Width="30px"></asp:TextBox>
                                        <cc1:FilteredTextBoxExtender ID="fltMobile1" runat="server" FilterType="Numbers, Custom" TargetControlID="txttop" ValidChars=".">
                                        </cc1:FilteredTextBoxExtender>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Font">
                                    <ItemTemplate>
                                        <asp:DropDownList ID="ddlfont" runat="server" Width="100px"></asp:DropDownList>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Size">

                                    <ItemTemplate>
                                        <asp:DropDownList ID="ddlfontsize" runat="server" Width="40px">
                                            <asp:ListItem Value="8">8</asp:ListItem>
                                            <asp:ListItem Value="9">9</asp:ListItem>
                                            <asp:ListItem Value="10">10</asp:ListItem>
                                            <asp:ListItem Value="11">11</asp:ListItem>
                                            <asp:ListItem Value="12">12</asp:ListItem>
                                            <asp:ListItem Value="13">13</asp:ListItem>
                                            <asp:ListItem Value="14">14</asp:ListItem>
                                        </asp:DropDownList>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Bold">
                                    <ItemTemplate>
                                        <asp:CheckBox ID="chbold" runat="server" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Print">

                                    <ItemTemplate>
                                        <asp:CheckBox ID="ch" runat="server" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <FooterStyle BackColor="White" ForeColor="#000066" />
                            <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" HorizontalAlign="Left" />
                            <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
                            <RowStyle ForeColor="#000066" />
                            <SelectedRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
                        </asp:GridView>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="row">
                        <div class="Purchaseheader" style="width: 98%">Preview </div>
                    </div>

                    <div class="row">
                        <asp:Image runat="server" Style="width: 94%; height: 400px; border: 1px solid black;" ID="mm" />
                    </div>
                </div>
                <div class="col-md-9">
                    <div class="row">
                        <div class="Purchaseheader" style="width: 98%">Saved Data </div>
                    </div>
                    <div class="row">
                        <asp:GridView ID="grd" Width="99%" runat="server" OnSelectedIndexChanged="grd_SelectedIndexChanged" AutoGenerateColumns="False" BackColor="White" BorderColor="#CC9966" BorderStyle="None" BorderWidth="1px" CellPadding="4" EnableModelValidation="True">
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">

                                    <ItemTemplate>
                                        <%# Container.DataItemIndex + 1 %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="FormName">

                                    <ItemTemplate>
                                        <asp:Label ID="Label2" runat="server" Text='<%# Bind("concentformname") %>'></asp:Label>
                                        <asp:Label ID="Label5" runat="server" Text='<%# Bind("id") %>' Visible="false"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="FileName">

                                    <ItemTemplate>
                                        <asp:Label ID="Label3" runat="server" Text='<%# Bind("Filename") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Entrydate">

                                    <ItemTemplate>
                                        <asp:Label ID="Label4" runat="server" Text='<%# Bind("endate") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Edit">

                                    <ItemTemplate>
                                        <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Select"
                                            Text="Select"></asp:LinkButton>
                                    </ItemTemplate>

                                </asp:TemplateField>
                            </Columns>
                            <FooterStyle BackColor="#FFFFCC" ForeColor="#330099" />
                            <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="#FFFFCC" HorizontalAlign="Left" />
                            <PagerStyle BackColor="#FFFFCC" ForeColor="#330099" HorizontalAlign="Center" />
                            <RowStyle BackColor="White" ForeColor="#330099" />
                            <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="#663399" />
                        </asp:GridView>
                    </div>
                </div>
            </div>

        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnsave" CssClass="itdosebtnnew" runat="server" Text="Save" OnClick="btnsave_Click" />
            <asp:Button ID="btnupdate" CssClass="itdosebtnnew" runat="server" Text="Update" OnClick="btnupdate_Click" Visible="false" />
        </div>
    </div>
     <cc1:ModalPopupExtender ID="modelmultiplepaymentmode" runat="server" CancelControlID="btncloseme" TargetControlID="Button1"
        BackgroundCssClass="filterPupupBackground" PopupControlID="panelmultiplepaymentmode">
    </cc1:ModalPopupExtender>
     <asp:Panel ID="panelmultiplepaymentmode" runat="server" Style="display: none;">
        <div class="POuter_Box_Inventory" style="width: 800px;height:650px; background-color: whitesmoke;">
            <div class="Purchaseheader">
            Preview
            </div>
            <asp:Image runat="server" Style="width: 94%; height: 600px; border: 1px solid black;" id="mm2"/>
            <center>
                
                <asp:Button ID="btncloseme" runat="server" CssClass="resetbutton" Text="Close" />
            </center>
        </div>
    </asp:Panel>
    <asp:Button ID="Button1" runat="server" Style="display: none;" />
</asp:Content>

