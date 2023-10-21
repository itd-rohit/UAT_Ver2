<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ViewTicket.aspx.cs" Inherits="Design_DashBoardNew_ViewTicket" %>

<!DOCTYPE html>
 <webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" /> 
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>View Ticket</title>
</head>
<body>
    <form id="form1" runat="server">
    <div id="body_box_inventory" style="width: 800px" >
       <div class="POuter_Box_Inventory" style="width: 800px" >
    <div class="content">
    <div style="text-align:center;">
    <b>View Ticket</b></div>
     <div style="text-align:center;">

         <asp:Label ID="lblerrmsg" runat="server" ForeColor="#FF0033"></asp:Label>&nbsp;</div>
   </div>
           </div>
          <div class="POuter_Box_Inventory" style="width: 800px" >
    <div class="content">
        <div class="Purchaseheader" style="width:97%">
            <asp:Label ID="lbinfo" runat="server"></asp:Label>
        </div>
        </div>
              </div>
     <div class="POuter_Box_Inventory" style="width: 800px" >
    <div class="content">
        <div style="width:98%;height:300px;overflow:scroll;">

            <asp:GridView ID="grd" Width="99%" runat="server" AutoGenerateColumns="False" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="3">
                <Columns>
                    <asp:TemplateField HeaderText="S.No.">
                       
                        <ItemTemplate>
                          <%# Container.DataItemIndex + 1 %>
                        </ItemTemplate>
                    </asp:TemplateField>
                     <asp:BoundField DataField="ID" HeaderText="Ticket No." HtmlEncode="False" DataFormatString="<a target='_blank' href='../CallCenter/AnswerTicket.aspx?TicketId={0}&Type=0,'><img src='../../App_Images/gmail.png' style='width:21px;' />{0}</a>" />
        
                    <asp:BoundField DataField="Status" HeaderText="Status" ItemStyle-Width="170px" />
                    <asp:BoundField DataField="GroupName" HeaderText="GroupName" ItemStyle-Width="200px" />
                    <asp:BoundField DataField="CategoryName" HeaderText="CategoryName" />
                    <asp:BoundField DataField="Subject" HeaderText="Subject" />
                     <asp:BoundField DataField="Message" HeaderText="Message" HtmlEncode="false" />
                     <asp:BoundField DataField="CreateBy" HeaderText="CreateBy" />
                     <asp:BoundField DataField="ElapsedTime" HeaderText="ElapsedTime" />

                   </Columns>
                <FooterStyle BackColor="White" ForeColor="#000066" />
                <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" HorizontalAlign="Left" />
                <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
                <RowStyle ForeColor="#000066" />
                <SelectedRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
                <SortedAscendingCellStyle BackColor="#F1F1F1" />
                <SortedAscendingHeaderStyle BackColor="#007DBB" />
                <SortedDescendingCellStyle BackColor="#CAC9C9" />
                <SortedDescendingHeaderStyle BackColor="#00547E" />

            </asp:GridView>

        </div>
        </div>
       </div>
    </div>
    </form>
</body>
</html>
