<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="StorageTypeMaster.aspx.cs" Inherits="Design_SampleStorage_StorageTypeMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        function ConfirmOnDelete(item, type) {
            var msg = "";
            if (type == "1") {
                msg = "Are you sure to deactive : " + item + "?";
            }
            else {
                msg = "Are you sure to active : " + item + "?";
            }
            if (confirm(msg) == true)
                return true;
            else
                return false;
        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    
            <div id="Pbody_box_inventory">
                <div class="POuter_Box_Inventory" style="text-align: center;">
                    <b>&nbsp;Sample Storage Type Master</b>&nbsp;<br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </div>
                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">
                        Add Details&nbsp;
                    </div>
                        <div class="row">
                            <div class="col-md-8">

                            </div>
                             <div class="col-md-3">
			                       <label class="pull-left">Storage Type Name</label>
			                       <b class="pull-right">:</b>
		                       </div>
                            <div class="col-md-6">
                                <asp:TextBox ID="txtdeptname" runat="server" Style="text-transform: uppercase;" CssClass="requiredField"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="r1" runat="server" ControlToValidate="txtdeptname" ErrorMessage="*Required" Font-Bold="true" ForeColor="Red" ValidationGroup="save"></asp:RequiredFieldValidator>
                            </div>
                            <div class="col-md-1">
                                <asp:TextBox ID="txtId" Visible="false" runat="server" />
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-5">
                                <asp:CheckBox ID="chkActive" runat="server" Checked="true" Text="Active" TextAlign="right" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="text-center col-md-5">
                                <asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" Text="Save" CssClass="savebutton" ValidationGroup="save" OnClientClick="return validate()" />
                                <asp:Button ID="btnUpdate" runat="server" OnClick="Unnamed_Click" Text="Update" CssClass="savebutton" ValidationGroup="save" />
                            </div>
                        </div>
                    
                </div>
                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">
                        Storage List
                    </div>
                            <div class="row" style="display:none">
                                <div class="col-md-3 col-md-offset-6">
			                       <label class="pull-left">Search By Name</label>
			                       <b class="pull-right">:</b>
		                       </div>
                                <div class="col-md-6">
                                    <asp:TextBox ID="txtsearch" runat="server"></asp:TextBox>
                                    <asp:Button ID="btnsearch" Text="Search" runat="server" OnClick="btnsearch_Click" CssClass="searchbutton" />
                                </div>
                            </div>
                                    <div style="overflow: scroll; height: 300px;">
                                        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" OnRowDeleting="GridView1_RowDeleting" OnSelectedIndexChanged="GridView1_SelectedIndexChanged" OnRowDataBound="GridView1_RowDataBound" Width="99%" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="3" EnableModelValidation="True">
                                            <Columns>
                                                <asp:TemplateField HeaderText="S.No.">
                                                    <ItemTemplate>
                                                        <%# Container.DataItemIndex + 1 %>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Name">

                                                    <EditItemTemplate>
                                                        <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("name") %>'></asp:TextBox>
                                                    </EditItemTemplate>
                                                    <ItemTemplate>
                                                        <asp:Label ID="Label2" runat="server" Text='<%# Bind("name") %>'></asp:Label>
                                                        <asp:Label ID="Label1" runat="server" Text='<%# Bind("id") %>' Visible="false"></asp:Label>
                                                        <asp:Label ID="Label3" runat="server" Text='<%# Bind("isactive") %>' Visible="false"></asp:Label>

                                                    </ItemTemplate>
                                                </asp:TemplateField>    
                                                <asp:BoundField DataField="status" HeaderText="Status" />
                                                  <asp:TemplateField HeaderText="Created By">
                                                       <ItemTemplate>
                                                           <asp:Label ID="Labedqeqel2" runat="server" Text='<%# Bind("CreatedBy") %>'></asp:Label>
                                                         </ItemTemplate>
                                                      </asp:TemplateField>
                                                 <asp:TemplateField HeaderText="Created On">
                                                       <ItemTemplate>
                                                           <asp:Label ID="Labedqeqfwffel2" runat="server" Text='<%# Bind("CreatedOn") %>'></asp:Label>
                                                         </ItemTemplate>
                                                      </asp:TemplateField>
                                            
                                                <asp:TemplateField HeaderText="Edit">

                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Select"
                                                            Text="Select"></asp:LinkButton>
                                                    </ItemTemplate>

                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="ChangeStatus" Visible="false">

                                                    <ItemTemplate>
                                                        <asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" CommandName="Delete"
                                                            Text="Deactive"></asp:LinkButton>
                                                    </ItemTemplate>

                                                </asp:TemplateField>
                                            </Columns>
                                            <FooterStyle BackColor="White" ForeColor="#000066" />
                                            <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" HorizontalAlign="Left" />
                                            <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
                                            <RowStyle ForeColor="#000066" HorizontalAlign="Left" />
                                            <SelectedRowStyle BackColor="Pink" Font-Bold="True" />
                                        </asp:GridView>
                                    </div>
            </div>
            </div>
        <script type="text/javascript">
            validate = function () {
                document.getElementById('<%=btnSave.ClientID%>').disabled = true;
              document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
              __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
          }
      </script>


</asp:Content>


