<%@ Page Language="C#" AutoEventWireup="true" CodeFile="QCAlert.aspx.cs" Inherits="Design_Quality_QCAlert" %>


<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
       <webopt:BundleReference ID="BundleReference4" runat="server" Path="~/App_Style/css" />
    <title></title>
</head>
<body>

   <form id="form1" runat="server">
      
<Ajax:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
      
        </Ajax:ScriptManager>
    
        <div id="Pbody_box_inventory" style="width:1105px;height:450px;">

             <div class="POuter_Box_Inventory" style="width:1100px;">

                <div class="content">

                <table width="99%">
                    <tr>
                        <td align="center">
                          <b>User Name :<span style="color:red;"><%=UserInfo.LoginName %></span> &nbsp;&nbsp;&nbsp;&nbsp;Centre Wise ILC Pending List of
                             <span style="color:red;"><%=DateTime.Now.ToString("MMMM") %>&nbsp;<%=DateTime.Now.Year.ToString() %></span>  </b>
                          
                        </td>
                    </tr>
                    </table>
                </div>


              </div>

             <div class="POuter_Box_Inventory" style="width:1100px;">
                 <div class="content">
                     <div style="width:100%;overflow:auto;">
            <asp:GridView ID="grd" Width="99%" runat="server" AutoGenerateColumns="False" BackColor="White" BorderColor="#CC9966" BorderStyle="None" BorderWidth="1px" CellPadding="4">
                <Columns>
                    <asp:TemplateField HeaderText="Sr.No">
                      
                        <ItemTemplate>
                            <%#Container.DataItemIndex+1 %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="ProcessingLabName" HeaderText="Centre Name" />
                    <asp:BoundField DataField="TotalMappedTest" HeaderText="Total Mapped"/>
                    <asp:BoundField DataField="RegisteredTest" HeaderText="Registered" />
                    <asp:BoundField DataField="ResultDone" HeaderText="Result Done" />
                    <asp:BoundField DataField="Approved" HeaderText="Approved" />
                     <asp:BoundField DataField="LastDateofregis" HeaderText="LastDate of Registration" />
                     <asp:BoundField DataField="LastDateofsave" HeaderText="LastDate of ResultSave" />
                </Columns>
                <FooterStyle BackColor="#FFFFCC" ForeColor="#330099" />
                <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="#FFFFCC" HorizontalAlign="Left" />
                <PagerStyle BackColor="#FFFFCC" ForeColor="#330099" HorizontalAlign="Center" />
                <RowStyle BackColor="White" ForeColor="#330099" />
                <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="#663399" />
                <SortedAscendingCellStyle BackColor="#FEFCEB" />
                <SortedAscendingHeaderStyle BackColor="#AF0101" />
                <SortedDescendingCellStyle BackColor="#F6F0C0" />
                <SortedDescendingHeaderStyle BackColor="#7E0000" />
            </asp:GridView>
                     </div></div>
                 </div>
    </div>
    </form>
</body>
</html>
