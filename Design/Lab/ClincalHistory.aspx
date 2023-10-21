<%@ Page Language="C#" AutoEventWireup="true" CodeFile="~/Design/Lab/ClincalHistory.aspx.cs" Inherits="Design_Lab_SampleTracking" %>

<!DOCTYPE html>
<webopt:BundleReference ID="BundleReference1" runat="server" Path="~/App_Style/css" />
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sample Status</title>
</head>
<body>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory" style="width: 836px;vertical-align:top;margin:-0px">
            <div class="POuter_Box_Inventory" style="width: 830px; text-align: center;">
                <b>Clincal History</b>
            </div>
            <div style="text-align: center;">
                <asp:Label ID="lblerrmsg" runat="server" ForeColor="#FF0033"></asp:Label>
            </div>

            <div class="POuter_Box_Inventory" style="width: 830px">
                <div  class="row">
                <div class="Purchaseheader">
                    <asp:Label ID="lbinfo" runat="server"></asp:Label>
                </div>
                     <div  class="row">
                      <div class="col-md-4">
			   <label class="pull-left">Clinical History   </label>
			   <b class="pull-right">:</b>
		   </div>
                        <div class="col-md-6">
                            <asp:TextBox ID="txtClinicalHistory" runat="server" TextMode="MultiLine" Rows="3" height="100px" Width="600px"></asp:TextBox>
                           
                        </div>
                          </div>
                         <div class="row">
                          <div class="col-md-6"></div><div class="col-md-4">
                          <asp:Button runat="server" ID="btnClincalUpdate" Text="Update" OnClick="btnClincalUpdate_Click" />
                      </div>
                         </div>
                    </div>
            </div>
             <div class="Outer_Box_Inventory" style="text-align: center; width: 99.6%;">
                     <div class="Purchaseheader">Clinical History Log</div>
                       <asp:GridView ID="grdLog" AutoGenerateColumns="False" runat="server" CssClass="GridViewStyle" Width="956px" >
                               
                                <Columns>
                                  
                                    <asp:BoundField DataField="UserName" HeaderText="UserName">
                                        <ItemStyle CssClass="exporttoexcel" />
                                        <HeaderStyle CssClass="exporttoexcelheader" />
                                    </asp:BoundField>
                                     <asp:BoundField DataField="dtEntry" HeaderText="DateTime">
                                        <ItemStyle CssClass="exporttoexcel" />
                                        <HeaderStyle CssClass="exporttoexcelheader" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="IpAddress" HeaderText="IpAddress">
                                        <ItemStyle CssClass="exporttoexcel" />
                                        <HeaderStyle CssClass="exporttoexcelheader" />
                                    </asp:BoundField>
                                   <asp:BoundField DataField="OldName" HeaderText="OLD History">
                                        <ItemStyle CssClass="exporttoexcel" />
                                        <HeaderStyle CssClass="exporttoexcelheader" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="NewName" HeaderText="New History">
                                        <ItemStyle CssClass="exporttoexcel" />
                                        <HeaderStyle CssClass="exporttoexcelheader" />
                                    </asp:BoundField>
                                </Columns>
                            </asp:GridView>
                      
                     </div>
    </div>

    </form>
</body>
</html>
