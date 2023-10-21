<%@ Page Title="" Language="C#"  MasterPageFile="~/Design/DefaultHome.master" AutoEventWireup="true" CodeFile="PrintSticker.aspx.cs" Inherits="Design_Lab_PrintSticker" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <script type="text/javascript">

        function SelectAllCheckboxes(chk) {
            $('#<%=grdshowdata.ClientID %>').find("input:checkbox").each(function () {
        if (this != chk) {
            this.checked = chk.checked;
        }
    });
}
</script>
    <ajax:scriptmanager AsyncPostBackErrorMessage="Error..." ID="ScriptManager1" runat="server">
  <Services>
  <Ajax:ServiceReference Path="~/Lis.asmx" />
  </Services>
     </ajax:scriptmanager>
      <div id="Pbody_box_inventory" style="width:1100px">
        <div id="DIV1" class="POuter_Box_Inventory" title="Click to Show/Hide Search Criteria." style="width: 1100px"  >
            <div class="content" style="text-align: center;">
                <b>Print Sticker</b>
                <br />
                <div style="float:right; clear:both;" id="div_pcount"></div>
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" /></div>
        </div>
        <div style="width: 1100px;"  id="SearchDiv" class="POuter_Box_Inventory"> <div class="Purchaseheader">Search Option</div>
           <div class="content" style="text-align: left;"> 
            
         <table width="100%">
             <tr>
                 <td>Lab No :</td>
                 <td><asp:TextBox ID="txtLabNo" runat="server"  CssClass="ItDoseTextinputText" Width="150px" /></td>
                 <td>From Lab No :</td>
                 <td><asp:TextBox ID="txtfromlabno" runat="server"  CssClass="ItDoseTextinputText" Width="150px" /></td>
                 <td>&nbsp;</td>
                 <td>To Lab No :</td>
                 <td>&nbsp;</td>
                 <td><asp:TextBox ID="txttolabno" runat="server"  CssClass="ItDoseTextinputText" Width="150px" /></td>
               
             </tr>
             <tr>
                 <td>From Date :</td>
                 <td>  <asp:TextBox ID="dtFrom" runat="server" Width="100px"></asp:TextBox>
                                <asp:Image ID="imgdtFrom" runat="server" ImageUrl="~/App_Images/ew_calendar.gif" />
                                <cc1:CalendarExtender runat="server" ID="ce_dtfrom"
                                        TargetControlID="dtFrom"
                                        Format="dd-MMM-yyyy"
                                        PopupButtonID="imgdtFrom" /></td>
                 <td>To date :</td>
                 <td><asp:TextBox ID="dtTo" runat="server" Width="100px"></asp:TextBox>
                                <asp:Image ID="imgdtTo" runat="server" ImageUrl="~/App_Images/ew_calendar.gif" />
                                <cc1:CalendarExtender runat="server" ID="ce_dtTo"
                                        TargetControlID="dtTo"
                                        Format="dd-MMM-yyyy"
                                        PopupButtonID="imgdtTo" /></td>
                 <td>&nbsp;</td>
                 <td>Starting From :</td>
                 <td>&nbsp;</td>
                 <td><asp:DropDownList ID="ddl" runat="server" >
                     <asp:ListItem>1</asp:ListItem>
                     
                     </asp:DropDownList></td>
               
             </tr>
             <tr>
                 <td>Center :</td>
                 <td><asp:DropDownList ID="ddlCentreAccess" Width="155px" onchange="Lock();" runat="server"></asp:DropDownList></td>
                 <td>Department :</td>
                 <td><asp:DropDownList ID="ddlDepartment" Width="155px" runat="server"></asp:DropDownList></td>
                 <td>&nbsp;</td>
                 <td>Panel :</td>
                 <td>&nbsp;</td>
                 <td><asp:DropDownList ID="ddlPanel" runat="server" Width="340px" ></asp:DropDownList></td>
               
             </tr>
             <tr>
                 <td colspan="8" style="text-align: center">
                     <asp:Button ID="print0" runat="server" Text="Search Data" OnClick="print0_Click" CssClass="ItDoseButton" />

                 &nbsp;&nbsp;&nbsp;
                     <asp:Button ID="print" runat="server" Text="Print Sticker" OnClick="print_Click" CssClass="ItDoseButton" />

                 </td>
               
             </tr>

             
         </table>
                </div>                                  
            
              
              
            </div>

          <div id="DIV2" class="POuter_Box_Inventory"  style="width: 1100px"  >
            <div class="content" style="text-align: center;">
                <table width="100%">

                    <tr>
                 <td colspan="6" style="text-align: left">

                     <div style="width:99%;height:400px;overflow:scroll;">
                     <asp:GridView ID="grdshowdata" runat="server" AutoGenerateColumns="False" EnableModelValidation="True" Width="100%" CellPadding="4" ForeColor="#333333" GridLines="None">
                         <AlternatingRowStyle BackColor="White" />
                         <Columns>
                             <asp:BoundField DataField="date" HeaderText="Date" />
                             <asp:BoundField DataField="labno" HeaderText="VisitNo" />
                             <asp:BoundField DataField="MRNO" HeaderText="MRNO" />
                              <asp:BoundField DataField="Pname" HeaderText="Pname" />
                             <asp:BoundField DataField="AGEGENDER" HeaderText="Age/Sex" />
                                                     
                             <asp:BoundField DataField="DisplayName" HeaderText="Department" />
                             <asp:BoundField DataField="itemname" HeaderText="Test Name" />
                             <asp:TemplateField>
                                 <EditItemTemplate>
                                     <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
                                 </EditItemTemplate>
                                 <ItemTemplate>
                                     <asp:CheckBox ID="chk" runat="server"  />
                                 </ItemTemplate>
                                 <HeaderTemplate>
                                     <asp:CheckBox ID="chheader" runat="server"  onclick="javascript:SelectAllCheckboxes(this);" />
                                 </HeaderTemplate>
                             </asp:TemplateField>
                         </Columns>
                         <EditRowStyle BackColor="#2461BF" />
                         <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                         <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" HorizontalAlign="Left" />
                         <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                         <RowStyle BackColor="#EFF3FB" />
                         <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                     </asp:GridView>
                    </div> </td>
                 </tr>
                </table>
                </div>
              </div>
        </div>
</asp:Content>

