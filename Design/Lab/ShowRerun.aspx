<%@ Page Title="" Language="C#" MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="ShowRerun.aspx.cs" Inherits="Design_Lab_ShowRerun" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

     <ajax:scriptmanager ID="ScriptManager1" runat="server">
        </ajax:scriptmanager>
        <Ajax:UpdateProgress id="updateProgress" runat="server">
    <ProgressTemplate>
        <div style="position: fixed; text-align: center; height: 100%; width: 100%; top: 0; right: 0; left: 0; z-index: 9999999; background-color: #000000; opacity: 0.7;">
            <span style="border-width: 0px; position: fixed; padding: 50px; background-color: #FFFFFF; font-size: 36px; left: 40%; top: 40%;">Loading <img src="../../App_Images/progress_bar.gif" /></span>
        </div>
    </ProgressTemplate>
</Ajax:UpdateProgress>
      <Ajax:UpdatePanel ID="mm" runat="server">
          <ContentTemplate> 


      <div id="Pbody_box_inventory" style="width:700px">
        <div class="POuter_Box_Inventory" style="width: 696px">
 <div class="content" style="text-align: left;">

     <div class="Purchaseheader">
               Rerun :: <asp:Label ID="lbtestname" runat="server"></asp:Label> </div>

     <asp:Label ID="lbmsg" Font-Size="Larger" ForeColor="Red" runat="server"></asp:Label>

    
     <div style="height:300px;overflow:auto;">
     <asp:GridView ID="grd" runat="server" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="Both">
         <AlternatingRowStyle BackColor="White" />
         <Columns>
             <asp:TemplateField HeaderText="SrNo">
               
                 <ItemTemplate>
                    <%# Container.DataItemIndex + 1 %>
                 </ItemTemplate>
             </asp:TemplateField>
             <asp:BoundField DataField="Name" HeaderText="Parameter" />
              <asp:TemplateField HeaderText="Value">
                 <ItemTemplate>
                    <asp:Label ID="lblValue"   Text='<%#Eval("Value") %>' runat="server"></asp:Label>
                      <asp:Label ID="lblBarCodeNo"   Visible="false" Text='<%#Eval("BarCodeNo") %>' runat="server"></asp:Label>
                 </ItemTemplate>
             </asp:TemplateField>
             <asp:TemplateField>
                
                 <ItemTemplate>
                     <asp:CheckBox ID="ch" runat="server" />
                     <asp:Label ID="label1"  Visible="false" Text='<%#Eval("labObservation_ID") %>' runat="server"></asp:Label>
                 </ItemTemplate>

                 <HeaderTemplate>
                     <asp:CheckBox ID="chheade" runat="server" AutoPostBack="true" OnCheckedChanged="chheade_CheckedChanged" />
                 </HeaderTemplate>
             </asp:TemplateField>
         </Columns>
         <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
         <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
         <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
         <RowStyle BackColor="#FFFBD6" ForeColor="#333333" />
         <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
         <SortedAscendingCellStyle BackColor="#FDF5AC" />
         <SortedAscendingHeaderStyle BackColor="#4D0000" />
         <SortedDescendingCellStyle BackColor="#FCF6C0" />
         <SortedDescendingHeaderStyle BackColor="#820000" />
     </asp:GridView>
    </div> 
      <br />
     <strong>Rerun Reason</strong>:<asp:TextBox ID="txtreason" runat="server" Width="300px" ></asp:TextBox>
     <br />
     <div> <asp:Button Text="Save Rerun" runat="server" OnClick="Unnamed_Click" CssClass="savebutton" ID="btnsave" style="float:left;padding-left:20px;" />

     <asp:Label ID="lb" runat="server" ForeColor="Red" style="float:left;padding-left:20px; font-weight: 700;"></asp:Label></div>
 </div>
            </div>
          </div>

              </ContentTemplate>

          
      </Ajax:UpdatePanel> 
</asp:Content>

