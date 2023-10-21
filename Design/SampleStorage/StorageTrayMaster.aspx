<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="StorageTrayMaster.aspx.cs" Inherits="Design_SampleStorage_StorageTrayMaster" %>
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

       function SearchEmployees1(txtSearch, cblEmployees) {
           if ($(txtSearch).val() != "") {
               var count = 0;
               $(cblEmployees).children('tbody').children('tr').each(function () {
                   var match = false;
                   $(this).children('td').children('span').children('label').each(function () {
                       if ($(this).text().toUpperCase().indexOf($(txtSearch).val().toUpperCase()) > -1)
                           match = true;
                   });
                   if (match) {
                       $(this).show();
                       count++;
                   }
                   else { $(this).hide(); }
               });
           }
           else {
               $(cblEmployees).children('tbody').children('tr').each(function () {
                   $(this).show();
               });
           }
       }
   </script>
   <Ajax:ScriptManager ID="ScriptManager1" runat="server">
   </Ajax:ScriptManager>
  
         <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center">
                <div class="row" style="text-align:center">
                    <b>Sample Storage Tray Master</b>
                </div>
              <div class="row" style="text-align:center">
               <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                     </div>
            </div>
            <div class="POuter_Box_Inventory">
               <div class="Purchaseheader">
                  Add Details&nbsp;
               </div>
                  <div class="row">
                     <div class="col-md-3">
			               <label class="pull-left">Tray Name</label>
			               <b class="pull-right">:</b>
		               </div>
                     <div class="col-md-5">
                            <asp:TextBox ID="txtdeptname" runat="server" Style="text-transform: uppercase;" CssClass="requiredField"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="r1" runat="server" ControlToValidate="txtdeptname" ErrorMessage="*Required" Font-Bold="true" ForeColor="Red" ValidationGroup="save"></asp:RequiredFieldValidator>
                     </div>
                     <div class="col-md-3">
			               <label class="pull-left">Storage Capacity   </label>
			               <b class="pull-right">:</b>
		               </div>
                     <div class="col-md-3">
                                <asp:TextBox ID="txtcap1" runat="server" CssClass="requiredField"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="txtcap3_filteredtextboxextender" runat="server" FilterType="Numbers" TargetControlID="txtcap1">
                                </cc1:FilteredTextBoxExtender>
                     </div>
                     <div class="col-md-1">
                                <b><span style="font-size:18px;">X</span>&nbsp;</b>                             
                      </div>
                     <div class="col-md-3">
                          <asp:TextBox ID="txtcap2" runat="server" CssClass="requiredField"></asp:TextBox>
                                 <cc1:FilteredTextBoxExtender ID="txtcap4_filteredtextboxextender" runat="server" FilterType="Numbers" TargetControlID="txtcap2">
                                </cc1:FilteredTextBoxExtender>
                                <asp:RequiredFieldValidator ID="r5" runat="server" ControlToValidate="txtcap1" ErrorMessage="*Required" Font-Bold="true" ForeColor="Red" ValidationGroup="save"></asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator ID="r6" runat="server" ControlToValidate="txtcap2" ErrorMessage="*Required" Font-Bold="true" ForeColor="Red" ValidationGroup="save"></asp:RequiredFieldValidator>                       
                      </div>
                  </div>
                  <div class="row">
                     <div class="col-md-3">
			               <label class="pull-left">Expiry duration</label>
			               <b class="pull-right">:</b>
		               </div>
                     <div class="col-md-5">
                        <asp:TextBox ID="txtexpiry" runat="server" CssClass="requiredField"></asp:TextBox>
                        <cc1:FilteredTextBoxExtender ID="txtexpiry0_filteredtextboxextender" runat="server" FilterType="Numbers" TargetControlID="txtexpiry">
                        </cc1:FilteredTextBoxExtender>
                        &nbsp;
                        <asp:DropDownList ID="ddlexpiry" runat="server">
                           <asp:ListItem Value="Days">Days</asp:ListItem>
                           <asp:ListItem Value="Months">Months</asp:ListItem>
                           <asp:ListItem Value="Years">Years</asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtexpiry" ErrorMessage="*Required" Font-Bold="true" ForeColor="Red" ValidationGroup="save"></asp:RequiredFieldValidator>
                     </div>
                     <div class="col-md-3 ">
                        <asp:CheckBox ID="chkActive" runat="server" Checked="true" Text="Active" TextAlign="right" />
                     </div>
                     <div class="col-md-5">
                        <asp:TextBox ID="txtId" runat="server" Visible="false" />
                     </div>
                  </div>
                  <div class="row">
                      <div class="col-md-3">
			               <label class="pull-left">Sample Type </label>
			               <b class="pull-right">:</b>
		               </div>
                      <div class="col-md-5">
                        <asp:TextBox onkeyup="SearchEmployees1(this,'#ContentPlaceHolder1_ddlsampletype');" ID="TextBox1" runat="server" placeholder="Search Sample"></asp:TextBox>
                      </div>
                  </div>
                   <div class="row">
                        <div style="height:170px;overflow:auto;border:1px solid;">
                           <asp:CheckBoxList ID="ddlsampletype" OnDataBound="chkdocument_DataBound" runat="server"  RepeatDirection="Horizontal" RepeatColumns="3">
                           </asp:CheckBoxList>
                        </div>
                   </div>
                  <div class="row">
                     <div class="col-md-5">
                        <asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" Text="Save" CssClass="savebutton" ValidationGroup="save" OnClientClick="return validate()" />
                        <asp:Button ID="btnUpdate" runat="server" OnClick="Unnamed_Click" Text="Update" CssClass="savebutton" ValidationGroup="save" />
                     </div>
                   </div>
            
            <div class="POuter_Box_Inventory">
               <div class="Purchaseheader">
                  Storage Tray List&nbsp;
               </div>
                   <div class="row">
                      <div class="col-md-5">
			               <label class="pull-left">Search By Name </label>
			               <b class="pull-right">:</b>
		               </div>
                       <div class="col-md-6">
                           <asp:TextBox ID="txtsearch" runat="server"></asp:TextBox>
                       </div>
                       <div class="col-md-3">
                           <asp:Button ID="btnsearch" Text="Search" runat="server" OnClick="btnsearch_Click" CssClass="searchbutton" />
                       </div>
                   </div>
                  <div class="row">
                        <div style="overflow: scroll; height: 200px;">
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
                                       <asp:Label ID="lbsampletypeid" runat="server" Text='<%# Bind("SampleTypeID") %>' Visible="false"></asp:Label>
                                       <asp:Label ID="lbcap1" runat="server" Text='<%# Bind("Capacity1") %>' Visible="false"></asp:Label>
                                       <asp:Label ID="lbcap2" runat="server" Text='<%# Bind("Capacity2") %>' Visible="false"></asp:Label>
                                       <asp:Label ID="lbexpunit" runat="server" Text='<%# Bind("ExpiryUnit") %>' Visible="false"></asp:Label>
                                       <asp:Label ID="lbexptype" runat="server" Text='<%# Bind("Expirytype") %>' Visible="false"></asp:Label>
                                    </ItemTemplate>
                                 </asp:TemplateField>
                                 <asp:TemplateField HeaderText="SampleType">
                                    <ItemTemplate>
                                       <asp:Label ID="txt1" runat="server" Text='<%# Bind("SampleTypeName") %>'></asp:Label>
                                    </ItemTemplate>
                                 </asp:TemplateField>
                                 <asp:TemplateField HeaderText="Storage Capacity">
                                    <ItemTemplate>
                                       <asp:Label ID="txt2" runat="server" Text='<%# Bind("Capacity") %>'></asp:Label>
                                    </ItemTemplate>
                                 </asp:TemplateField>
                                 <asp:TemplateField HeaderText="Expiry Duration">
                                    <ItemTemplate>
                                       <asp:Label ID="txt3" runat="server" Text='<%# Bind("Expiry") %>'></asp:Label>
                                    </ItemTemplate>
                                 </asp:TemplateField>
                                 <asp:BoundField DataField="status" HeaderText="Status" />
                                 <asp:BoundField DataField="createdby" HeaderText="Created By" />
                                 <asp:BoundField DataField="createdon" HeaderText="Created On" />
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